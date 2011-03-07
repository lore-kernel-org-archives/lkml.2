Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1CGQft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:35:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41822 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1CGQfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:35:48 -0500
MIME-Version: 1.0
In-Reply-To: <4D745D1F.2070808@fastmail.fm>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D745D1F.2070808@fastmail.fm>
Date: Mon, 7 Mar 2011 10:35:47 -0600
Message-ID: <AANLkTi=h0MkySh+VjrdohLzTB-NqSmmZOKcRtGRyHTg=@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack:


On Sun, Mar 6, 2011 at 10:20 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
> On 06/03/2011 04:17, Bill Gatliff wrote:
>> +The Generic PWM Device API framework is implemented in
>> +include/linux/pwm/pwm.h and drivers/pwm/pwm.c.  The functions therein
>> +use information from pwm_device and pwm__config structures to invoke
>
> Could you fix that to be pwm_config please.

Fixed.

>> +menuconfig GENERIC_PWM
>> +     tristate "PWM Support"
>> +     help
>> +       Enables PWM device support implemented via a generic
>> +       framework.  If unsure, say N.
>> +
>
> Does this need help text? Can't we just select GENERIC_PWM for the
> drivers / users that need it?

That would be my preference, actually.  I'll see if I can do that at
the next review.

>> +
>> +     if (p->ops->request) {
>> +             ret = p->ops->request(p);
>> +             if (ret) {
>> +                     clear_bit(FLAG_REQUESTED, &p->flags);
>> +                     goto done;
>
> You don't need this goto here.

Fixed.

>> +struct pwm_device *pwm_request(const char *bus_id, int id, const char *label)
>> +{
>> +     char name[256];
>> +     int ret;
>> +
>> +     if (id == -1)
>> +             ret = scnprintf(name, sizeof name, "%s", bus_id);
>
> Kernel doc comment for the function to describe the id == -1 case?

Fixed.

>> +static void pwm_handler(struct work_struct *w)
>> +{
>> +     struct pwm_device *p = container_of(w, struct pwm_device,
>> +                                         handler_work);
>
>        You could just not queue the work if !p->handler

Good point.  Fixed.

>> +     if (id == -1)
>> +             ret = scnprintf(name, sizeof name, "%s", dev_name(parent));
>
> A kernel doc comment to explain id == -1 would be nice.
>

Fixed.

> Very nice framework!

Thank you!!

>
> Would be nice to have kernel doc comments for the functions but that can
> follow on later.

I'll try to do some of it for the next review series.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
