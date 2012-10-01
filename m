Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2JAKL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:11:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37600 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2JAKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <4890463.n9c9znHmVK@avalon>
References: <1349078519-22828-1-git-send-email-prabhakar.lad@ti.com> <4890463.n9c9znHmVK@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 1 Oct 2012 15:41:35 +0530
Message-ID: <CA+V-a8vaQwfUKiupUD_TXRVkvv0kWFOFXkXm+L5NE9qMG3aO+Q@mail.gmail.com>
Subject: Re: [PATCH v3] media: mt9p031/mt9t001/mt9v032: use
 V4L2_CID_TEST_PATTERN for test pattern control
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Mon, Oct 1, 2012 at 3:12 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thanks for the patch.
>
> On Monday 01 October 2012 13:31:59 Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> ---
>>  Changes for v3:
>>  1: Used cluster in mt9v032 for test pattern,
>>  pointed by Laurent.
>>
>>  Changes for v2:
>>  1: Fixed review comments pointed by Laurent.
>>
>>  drivers/media/i2c/mt9p031.c |   19 +++----------
>>  drivers/media/i2c/mt9t001.c |   22 ++++++++++-----
>>  drivers/media/i2c/mt9v032.c |   60 +++++++++++++++++++++++++---------------
>>  3 files changed, 58 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
>> index 2c0f407..e328332 100644
>> --- a/drivers/media/i2c/mt9p031.c
>> +++ b/drivers/media/i2c/mt9p031.c
>> @@ -574,7 +574,6 @@ static int mt9p031_set_crop(struct v4l2_subdev *subdev,
>>   * V4L2 subdev control operations
>>   */
>>
>> -#define V4L2_CID_TEST_PATTERN                (V4L2_CID_USER_BASE | 0x1001)
>>  #define V4L2_CID_BLC_AUTO            (V4L2_CID_USER_BASE | 0x1002)
>>  #define V4L2_CID_BLC_TARGET_LEVEL    (V4L2_CID_USER_BASE | 0x1003)
>>  #define V4L2_CID_BLC_ANALOG_OFFSET   (V4L2_CID_USER_BASE | 0x1004)
>> @@ -740,18 +739,6 @@ static const char * const mt9p031_test_pattern_menu[] =
>> { static const struct v4l2_ctrl_config mt9p031_ctrls[] = {
>>       {
>>               .ops            = &mt9p031_ctrl_ops,
>> -             .id             = V4L2_CID_TEST_PATTERN,
>> -             .type           = V4L2_CTRL_TYPE_MENU,
>> -             .name           = "Test Pattern",
>> -             .min            = 0,
>> -             .max            = ARRAY_SIZE(mt9p031_test_pattern_menu) - 1,
>> -             .step           = 0,
>> -             .def            = 0,
>> -             .flags          = 0,
>> -             .menu_skip_mask = 0,
>> -             .qmenu          = mt9p031_test_pattern_menu,
>> -     }, {
>> -             .ops            = &mt9p031_ctrl_ops,
>>               .id             = V4L2_CID_BLC_AUTO,
>>               .type           = V4L2_CTRL_TYPE_BOOLEAN,
>>               .name           = "BLC, Auto",
>> @@ -950,7 +937,7 @@ static int mt9p031_probe(struct i2c_client *client,
>>       mt9p031->model = did->driver_data;
>>       mt9p031->reset = -1;
>>
>> -     v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 5);
>> +     v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
>>
>>       v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
>>                         V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
>> @@ -966,6 +953,10 @@ static int mt9p031_probe(struct i2c_client *client,
>>       v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
>>                         V4L2_CID_PIXEL_RATE, pdata->target_freq,
>>                         pdata->target_freq, 1, pdata->target_freq);
>> +     v4l2_ctrl_new_std_menu_items(&mt9p031->ctrls, &mt9p031_ctrl_ops,
>> +                       V4L2_CID_TEST_PATTERN,
>> +                       ARRAY_SIZE(mt9p031_test_pattern_menu) - 1, 0,
>> +                       0, mt9p031_test_pattern_menu);
>>
>>       for (i = 0; i < ARRAY_SIZE(mt9p031_ctrls); ++i)
>>               v4l2_ctrl_new_custom(&mt9p031->ctrls, &mt9p031_ctrls[i], NULL);
>> diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
>> index 6d343ad..2e189d8 100644
>> --- a/drivers/media/i2c/mt9t001.c
>> +++ b/drivers/media/i2c/mt9t001.c
>> @@ -371,7 +371,7 @@ static int mt9t001_set_crop(struct v4l2_subdev *subdev,
>>   * V4L2 subdev control operations
>>   */
>>
>> -#define V4L2_CID_TEST_PATTERN                (V4L2_CID_USER_BASE | 0x1001)
>> +#define V4L2_CID_TEST_PATTERN_COLOR  (V4L2_CID_USER_BASE | 0x1001)
>>  #define V4L2_CID_BLACK_LEVEL_AUTO    (V4L2_CID_USER_BASE | 0x1002)
>>  #define V4L2_CID_BLACK_LEVEL_OFFSET  (V4L2_CID_USER_BASE | 0x1003)
>>  #define V4L2_CID_BLACK_LEVEL_CALIBRATE       (V4L2_CID_USER_BASE | 0x1004)
>> @@ -487,12 +487,11 @@ static int mt9t001_s_ctrl(struct v4l2_ctrl *ctrl)
>>                                    ctrl->val >> 16);
>>
>>       case V4L2_CID_TEST_PATTERN:
>> -             ret = mt9t001_set_output_control(mt9t001,
>> +             return mt9t001_set_output_control(mt9t001,
>>                       ctrl->val ? 0 : MT9T001_OUTPUT_CONTROL_TEST_DATA,
>>                       ctrl->val ? MT9T001_OUTPUT_CONTROL_TEST_DATA : 0);
>> -             if (ret < 0)
>> -                     return ret;
>>
>> +     case V4L2_CID_TEST_PATTERN_COLOR:
>>               return mt9t001_write(client, MT9T001_TEST_DATA, ctrl->val << 2);
>>
>>       case V4L2_CID_BLACK_LEVEL_AUTO:
>> @@ -533,12 +532,17 @@ static struct v4l2_ctrl_ops mt9t001_ctrl_ops = {
>>       .s_ctrl = mt9t001_s_ctrl,
>>  };
>>
>> +static const char * const mt9t001_test_pattern_menu[] = {
>> +     "Disabled",
>> +     "Enabled",
>> +};
>> +
>>  static const struct v4l2_ctrl_config mt9t001_ctrls[] = {
>>       {
>>               .ops            = &mt9t001_ctrl_ops,
>> -             .id             = V4L2_CID_TEST_PATTERN,
>> +             .id             = V4L2_CID_TEST_PATTERN_COLOR,
>>               .type           = V4L2_CTRL_TYPE_INTEGER,
>> -             .name           = "Test pattern",
>> +             .name           = "Test Pattern Color",
>>               .min            = 0,
>>               .max            = 1023,
>>               .step           = 1,
>> @@ -741,7 +745,7 @@ static int mt9t001_probe(struct i2c_client *client,
>>               return -ENOMEM;
>>
>>       v4l2_ctrl_handler_init(&mt9t001->ctrls, ARRAY_SIZE(mt9t001_ctrls) +
>> -                                             ARRAY_SIZE(mt9t001_gains) + 3);
>> +                                             ARRAY_SIZE(mt9t001_gains) + 4);
>>
>>       v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
>>                         V4L2_CID_EXPOSURE, MT9T001_SHUTTER_WIDTH_MIN,
>> @@ -752,6 +756,10 @@ static int mt9t001_probe(struct i2c_client *client,
>>       v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
>>                         V4L2_CID_PIXEL_RATE, pdata->ext_clk, pdata->ext_clk,
>>                         1, pdata->ext_clk);
>> +     v4l2_ctrl_new_std_menu_items(&mt9t001->ctrls, &mt9t001_ctrl_ops,
>> +                     V4L2_CID_TEST_PATTERN,
>> +                     ARRAY_SIZE(mt9t001_test_pattern_menu) - 1, 0,
>> +                     0, mt9t001_test_pattern_menu);
>>
>>       for (i = 0; i < ARRAY_SIZE(mt9t001_ctrls); ++i)
>>               v4l2_ctrl_new_custom(&mt9t001->ctrls, &mt9t001_ctrls[i], NULL);
>> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
>> index e217740..a0a37ba 100644
>> --- a/drivers/media/i2c/mt9v032.c
>> +++ b/drivers/media/i2c/mt9v032.c
>> @@ -141,6 +141,10 @@ struct mt9v032 {
>>       u16 chip_control;
>>       u16 aec_agc;
>>       u16 hblank;
>> +     struct {
>> +             struct v4l2_ctrl *test_pattern;
>> +             struct v4l2_ctrl *test_pattern_color;
>> +     };
>>  };
>>
>>  static struct mt9v032 *to_mt9v032(struct v4l2_subdev *sd)
>> @@ -500,7 +504,7 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
>>   * V4L2 subdev control operations
>>   */
>>
>> -#define V4L2_CID_TEST_PATTERN                (V4L2_CID_USER_BASE | 0x1001)
>> +#define V4L2_CID_TEST_PATTERN_COLOR  (V4L2_CID_USER_BASE | 0x1001)
>>
>>  static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>>  {
>> @@ -545,7 +549,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>>               break;
>>
>>       case V4L2_CID_TEST_PATTERN:
>> -             switch (ctrl->val) {
>> +             switch (mt9v032->test_pattern->val) {
>>               case 0:
>>                       data = 0;
>>                       break;
>> @@ -562,13 +566,13 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>>
>>                            | MT9V032_TEST_PATTERN_ENABLE;
>>
>>                       break;
>>               default:
>> -                     data = (ctrl->val << MT9V032_TEST_PATTERN_DATA_SHIFT)
>> -                          | MT9V032_TEST_PATTERN_USE_DATA
>> -                          | MT9V032_TEST_PATTERN_ENABLE
>> -                          | MT9V032_TEST_PATTERN_FLIP;
>> +                     data = (mt9v032->test_pattern_color->val <<
>> +                             MT9V032_TEST_PATTERN_DATA_SHIFT) |
>> +                             MT9V032_TEST_PATTERN_USE_DATA |
>> +                             MT9V032_TEST_PATTERN_ENABLE |
>> +                             MT9V032_TEST_PATTERN_FLIP;
>
> Can you keep the | aligned on the = (and the M of
> MT9V032_TEST_PATTERN_DATA_SHIFT aligned on the m of mt9v032-
>>test_pattern_color->val) ? There will be less lines changed then.
>

Done.

>>                       break;
>>               }
>> -
>>               return mt9v032_write(client, MT9V032_TEST_PATTERN, data);
>>       }
>>
>> @@ -579,18 +583,24 @@ static struct v4l2_ctrl_ops mt9v032_ctrl_ops = {
>>       .s_ctrl = mt9v032_s_ctrl,
>>  };
>>
>> -static const struct v4l2_ctrl_config mt9v032_ctrls[] = {
>> -     {
>> -             .ops            = &mt9v032_ctrl_ops,
>> -             .id             = V4L2_CID_TEST_PATTERN,
>> -             .type           = V4L2_CTRL_TYPE_INTEGER,
>> -             .name           = "Test pattern",
>> -             .min            = 0,
>> -             .max            = 1023,
>> -             .step           = 1,
>> -             .def            = 0,
>> -             .flags          = 0,
>> -     }
>> +static const char * const mt9v032_test_pattern_menu[] = {
>> +     "Disabled",
>> +     "Gray Vertical Shade",
>> +     "Gray Horizontal Shade",
>> +     "Gray Diagonal Shade",
>> +     "Plain",
>> +};
>> +
>> +static const struct v4l2_ctrl_config mt9v032_test_patter_color = {
>
> s/patter/pattern/
>
> and below too.
>
Ok.

Regards,
--Prabhakar

>> +     .ops            = &mt9v032_ctrl_ops,
>> +     .id             = V4L2_CID_TEST_PATTERN_COLOR,
>> +     .type           = V4L2_CTRL_TYPE_INTEGER,
>> +     .name           = "Test Pattern Color",
>> +     .min            = 4,
>> +     .max            = 1023,
>> +     .step           = 1,
>> +     .def            = 4,
>> +     .flags          = 0,
>>  };
>>
>>  /*
>> ---------------------------------------------------------------------------
>> -- @@ -741,7 +751,7 @@ static int mt9v032_probe(struct i2c_client *client,
>> mutex_init(&mt9v032->power_lock);
>>       mt9v032->pdata = pdata;
>>
>> -     v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 8);
>> +     v4l2_ctrl_handler_init(&mt9v032->ctrls, 10);
>>
>>       v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
>>                         V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
>> @@ -763,6 +773,14 @@ static int mt9v032_probe(struct i2c_client *client,
>>                         V4L2_CID_VBLANK, MT9V032_VERTICAL_BLANKING_MIN,
>>                         MT9V032_VERTICAL_BLANKING_MAX, 1,
>>                         MT9V032_VERTICAL_BLANKING_DEF);
>> +     mt9v032->test_pattern = v4l2_ctrl_new_std_menu_items(&mt9v032->ctrls,
>> +                             &mt9v032_ctrl_ops, V4L2_CID_TEST_PATTERN,
>> +                             ARRAY_SIZE(mt9v032_test_pattern_menu) - 1, 0, 0,
>> +                             mt9v032_test_pattern_menu);
>> +     mt9v032->test_pattern_color = v4l2_ctrl_new_custom(&mt9v032->ctrls,
>> +                                   &mt9v032_test_patter_color, NULL);
>> +
>> +     v4l2_ctrl_cluster(2, &mt9v032->test_pattern);
>>
>>       mt9v032->pixel_rate =
>>               v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
>> @@ -784,8 +802,6 @@ static int mt9v032_probe(struct i2c_client *client,
>>               v4l2_ctrl_cluster(2, &mt9v032->link_freq);
>>       }
>>
>> -     for (i = 0; i < ARRAY_SIZE(mt9v032_ctrls); ++i)
>> -             v4l2_ctrl_new_custom(&mt9v032->ctrls, &mt9v032_ctrls[i], NULL);
>>
>>       mt9v032->subdev.ctrl_handler = &mt9v032->ctrls;
> --
> Regards,
>
> Laurent Pinchart
>
