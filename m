Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab2DTDId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:08:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65359 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2DTDIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:08:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120420030046.GA17274@kroah.com>
References: <20120418214703.GA31606@kroah.com>
	<1334803298-24260-1-git-send-email-myungjoo.ham@samsung.com>
	<1334803298-24260-2-git-send-email-myungjoo.ham@samsung.com>
	<20120420023704.GA1399@kroah.com>
	<CAH9JG2WRXPVuJz2mDYB+r=6n1FOwzSRwAFiJ35oTVz8E59dp7w@mail.gmail.com>
	<20120420024920.GA17151@kroah.com>
	<CAH9JG2X6KUhPyKkTVgwG5grdmxoyPM4xGVn3J+cRG-KzPOHL_g@mail.gmail.com>
	<20120420030046.GA17274@kroah.com>
Date: Fri, 20 Apr 2012 12:08:32 +0900
X-Google-Sender-Auth: Bni9gL33rvGJefnemU38y455sCg
Message-ID: <CAH9JG2XvYqa7W-PTbq6JrY3LGoFqKkdBfcGJ73HbynqM9ZvhjQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/6] Extcon (external connector): import Android's
 switch class and modify.
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/12, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 20, 2012 at 11:57:26AM +0900, Kyungmin Park wrote:
>> On 4/20/12, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Fri, Apr 20, 2012 at 11:46:25AM +0900, Kyungmin Park wrote:
>> >> On 4/20/12, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> > On Thu, Apr 19, 2012 at 11:41:33AM +0900, MyungJoo Ham wrote:
>> >> >> External connector class (extcon) is based on and an extension of
>> >> >> Android kernel's switch class located at linux/drivers/switch/.
>> >> >
>> >> > Oh come on, this still breaks the build, it is as if you didn't even
>> >> > test this at all, or modify anything since I reported it as a problem
>> >> > to
>> >> > you yesterday:
>> >> >
>> >> > drivers/extcon/extcon_class.c:79:6: error: redefinition of
>> >> > ‘extcon_set_state’
>> >> > include/linux/extcon.h:80:20: note: previous definition of
>> >> > ‘extcon_set_state’ was here
>> >> > drivers/extcon/extcon_class.c:170:5: error: redefinition of
>> >> > ‘extcon_dev_register’
>> >> > include/linux/extcon.h:67:19: note: previous definition of
>> >> > ‘extcon_dev_register’ was here
>> >> > drivers/extcon/extcon_class.c:214:6: error: redefinition of
>> >> > ‘extcon_dev_unregister’
>> >> > include/linux/extcon.h:73:20: note: previous definition of
>> >> > ‘extcon_dev_unregister’ was here
>> >> >
>> >> > You can do better than this, I know you can.
>> >>
>> >> Umm. can you show your EXTCON config? I think you build it as module.
>> >> it's tested it extcon on or not. anyway I'll test it as module and
>> >> check it.
>> >
>> > Yes, I selected to build it as a module, which, according to your patch,
>> > is a valid selection.
>>
>> Found, need to add CONFIG_EXTCON_MODULE at below.
>
> You do know we have a new macro that handles all of this for you,
> IS_ENABLED().  It handles the _MODULE stuff and the other stuff as well,
> and you can put it in a .c expression also.
>
> Try using that instead.

No problem, send patches with it.

BTW, can we post it after one hour?

Thank you,
Kyungmin Park
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
