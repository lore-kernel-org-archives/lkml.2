Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2ISJE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:04:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58979 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2ISJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:04:23 -0400
MIME-Version: 1.0
In-Reply-To: <201209190953.45560.hverkuil@xs4all.nl>
References: <1347994478-31784-1-git-send-email-prabhakar.lad@ti.com> <201209190953.45560.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 19 Sep 2012 14:34:01 +0530
Message-ID: <CA+V-a8tj3LpVYy4=hZfvEP3Bmf3JXqxg-ThkBJuCsfSuNMqVvA@mail.gmail.com>
Subject: Re: [PATCH v4] media: v4l2-ctrl: add a helper function to add
 standard control with driver specific menu
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org, "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Wed, Sep 19, 2012 at 1:23 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> I found some grammar issues, but also some (small) things that should be changed.
>
>
> On Tue 18 September 2012 20:54:38 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Add helper function v4l2_ctrl_new_std_menu_items(), which adds
>> a standard menu control, with driver specific menu.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Rob Landley <rob@landley.net>
>> ---
>> Changes for v4:
>> 1: Rather then adding a function to modify the menu, added a helper
>>    function, that creates a new standard control with user specific
>>    menu.
>>
>> Changes for v3:
>> 1: Fixed style/grammer issues as pointed by Hans.
>>    Thanks Hans for providing the description.
>>
>> Changes for v2:
>> 1: Fixed review comments from Hans, to have return type as
>>    void, add WARN_ON() for fail conditions, allow this fucntion
>>    to modify the menu of custom controls.
>>
>>  Documentation/video4linux/v4l2-controls.txt |   25 ++++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c        |   28 +++++++++++++++++++++++++++
>>  include/media/v4l2-ctrls.h                  |   23 ++++++++++++++++++++++
>>  3 files changed, 76 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
>> index 43da22b..ad8e172 100644
>> --- a/Documentation/video4linux/v4l2-controls.txt
>> +++ b/Documentation/video4linux/v4l2-controls.txt
>> @@ -136,11 +136,25 @@ Or alternatively for integer menu controls, by calling v4l2_ctrl_new_int_menu:
>>                       const struct v4l2_ctrl_ops *ops,
>>                       u32 id, s32 max, s32 def, const s64 *qmenu_int);
>>
>> +Standard menu controls with driver specific menu are added by calling
>
> with driver -> with a driver
>
Ok.

>> +v4l2_ctrl_new_std_menu_items:
>> +
>> +     struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(
>> +             struct v4l2_ctrl_handler *hdl,
>> +             const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
>> +             s32 skip_mask, s32 def, const char * const *qmenu_user);
>
> I would recommend that qmenu_user is just renamed to qmenu.
> The _user suffix suggests that this is a userspace-provided menu, which
> is not the case.
>
Ok.

>> +
>>  These functions are typically called right after the v4l2_ctrl_handler_init:
>>
>>       static const s64 exp_bias_qmenu[] = {
>>              -2, -1, 0, 1, 2
>>       };
>> +     static const char * const test_pattern[] = {
>> +             "Disabled",
>> +             "Vertical Bars",
>> +             "Solid Black",
>> +             "Solid White",
>> +     };
>>
>>       v4l2_ctrl_handler_init(&foo->ctrl_handler, nr_of_controls);
>>       v4l2_ctrl_new_std(&foo->ctrl_handler, &foo_ctrl_ops,
>> @@ -156,6 +170,9 @@ These functions are typically called right after the v4l2_ctrl_handler_init:
>>                       ARRAY_SIZE(exp_bias_qmenu) - 1,
>>                       ARRAY_SIZE(exp_bias_qmenu) / 2 - 1,
>>                       exp_bias_qmenu);
>> +     v4l2_ctrl_new_std_menu_items(&foo->ctrl_handler, &foo_ctrl_ops,
>> +                     V4L2_CID_TEST_PATTERN, ARRAY_SIZE(test_pattern) - 1, 0,
>> +                     0, test_pattern);
>>       ...
>>       if (foo->ctrl_handler.error) {
>>               int err = foo->ctrl_handler.error;
>> @@ -185,6 +202,14 @@ v4l2_ctrl_new_std_menu in that it doesn't have the mask argument and takes
>>  as the last argument an array of signed 64-bit integers that form an exact
>>  menu item list.
>>
>> +The v4l2_ctrl_new_std_menu_items funtion is very similar as
>
> funtion -> function
> similar as -> similar to
>
Ok.
>> +v4l2_ctrl_new_std_menu but takes a extra parameter qmenu_user, which is
>
> a extra -> an extra
>
>> +driver specific menu but yet a standard menu control.
>
> the driver specific menu for an otherwise standard menu control.
>
Ok.

>> +A good example for this control is the test pattern control for
>> +capture/display/sensors devices that have the capability to generate test
>> +patterns. These test patterns are hardware specific, so the contents of the
>> +menu will vary from device to device.
>> +
>>  Note that if something fails, the function will return NULL or an error and
>>  set ctrl_handler->error to the error code. If ctrl_handler->error was already
>>  set, then it will just return and do nothing. This is also true for
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index d731422..9ac1b75 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1649,6 +1649,34 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
>>
>> +/* Helper function for standard menu controls with user defined menu */
>> +struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
>> +                     const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
>> +                     s32 mask, s32 def, const char * const *qmenu_user)
>> +{
>> +     const char * const *qmenu = v4l2_ctrl_get_menu(id);
>> +     const char *name;
>> +     enum v4l2_ctrl_type type;
>> +     s32 min;
>> +     s32 step;
>> +     u32 flags;
>> +
>> +     if (!qmenu) {
>
> This test should be inverted: if (qmenu)
>
This check is if it really belongs standard menu control, here
qmenu is filled by v4l2_ctrl_get_menu(), If it returns null its a error case.

> Add a comment that v4l2_ctrl_new_std_menu_items() may only be called for
> standard controls *without* a standard menu.
>
Ok.
>> +             handler_set_err(hdl, -EINVAL);
>> +             return NULL;
>> +     }
>> +
>> +     v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
>> +     if (type != V4L2_CTRL_TYPE_MENU) {
>> +             handler_set_err(hdl, -EINVAL);
>> +             return NULL;
>> +     }
>> +     return v4l2_ctrl_new(hdl, ops, id, name, type,
>> +                          0, max, mask, def, flags, qmenu_user, NULL, NULL);
>> +
>> +}
>> +EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
>> +
>>  /* Helper function for standard integer menu controls */
>>  struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
>>                       const struct v4l2_ctrl_ops *ops,
>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>> index 776605f..e0dd392 100644
>> --- a/include/media/v4l2-ctrls.h
>> +++ b/include/media/v4l2-ctrls.h
>> @@ -351,6 +351,29 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
>>                       const struct v4l2_ctrl_ops *ops,
>>                       u32 id, s32 max, s32 mask, s32 def);
>>
>> +/** v4l2_ctrl_new_std_menu_items() - Create a new standard V4L2 menu control
>> +  * with driver specific menu.
>> +  * @hdl:    The control handler.
>> +  * @ops:    The control ops.
>> +  * @id:     The control ID.
>> +  * @max:    The control's maximum value.
>> +  * @mask:   The control's skip mask for menu controls. This makes it
>> +  *          easy to skip menu items that are not valid. If bit X is set,
>> +  *          then menu item X is skipped. Of course, this only works for
>> +  *          menus with <= 32 menu items. There are no menus that come
>> +  *          close to that number, so this is OK. Should we ever need more,
>> +  *          then this will have to be extended to a u64 or a bit array.
>> +  * @def:    The control's default value.
>> +  * @qmenu_user:The new menu.
>> +  *
>> +  * Same as v4l2_ctrl_new_std_menu().but @qmenu_user will be the menu to
>
> .but -> , but
>
> 'will be the driver specific menu of this control.'
>
Ok.

Regards,
--Prabhakar

>> +  * which the control will be pointing to.
>> +  *
>> +  */
>> +struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
>> +                     const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
>> +                     s32 mask, s32 def, const char * const *qmenu_user);
>> +
>>  /** v4l2_ctrl_new_int_menu() - Create a new standard V4L2 integer menu control.
>>    * @hdl:    The control handler.
>>    * @ops:    The control ops.
>>
>
> Regards,
>
>         Hans
