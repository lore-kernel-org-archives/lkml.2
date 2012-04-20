Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2DTDAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:00:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42228 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab2DTDAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:00:51 -0400
Date: Thu, 19 Apr 2012 20:00:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v8 1/6] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120420030046.GA17274@kroah.com>
References: <20120418214703.GA31606@kroah.com>
 <1334803298-24260-1-git-send-email-myungjoo.ham@samsung.com>
 <1334803298-24260-2-git-send-email-myungjoo.ham@samsung.com>
 <20120420023704.GA1399@kroah.com>
 <CAH9JG2WRXPVuJz2mDYB+r=6n1FOwzSRwAFiJ35oTVz8E59dp7w@mail.gmail.com>
 <20120420024920.GA17151@kroah.com>
 <CAH9JG2X6KUhPyKkTVgwG5grdmxoyPM4xGVn3J+cRG-KzPOHL_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH9JG2X6KUhPyKkTVgwG5grdmxoyPM4xGVn3J+cRG-KzPOHL_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 11:57:26AM +0900, Kyungmin Park wrote:
> On 4/20/12, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Apr 20, 2012 at 11:46:25AM +0900, Kyungmin Park wrote:
> >> On 4/20/12, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Thu, Apr 19, 2012 at 11:41:33AM +0900, MyungJoo Ham wrote:
> >> >> External connector class (extcon) is based on and an extension of
> >> >> Android kernel's switch class located at linux/drivers/switch/.
> >> >
> >> > Oh come on, this still breaks the build, it is as if you didn't even
> >> > test this at all, or modify anything since I reported it as a problem to
> >> > you yesterday:
> >> >
> >> > drivers/extcon/extcon_class.c:79:6: error: redefinition of
> >> > ‘extcon_set_state’
> >> > include/linux/extcon.h:80:20: note: previous definition of
> >> > ‘extcon_set_state’ was here
> >> > drivers/extcon/extcon_class.c:170:5: error: redefinition of
> >> > ‘extcon_dev_register’
> >> > include/linux/extcon.h:67:19: note: previous definition of
> >> > ‘extcon_dev_register’ was here
> >> > drivers/extcon/extcon_class.c:214:6: error: redefinition of
> >> > ‘extcon_dev_unregister’
> >> > include/linux/extcon.h:73:20: note: previous definition of
> >> > ‘extcon_dev_unregister’ was here
> >> >
> >> > You can do better than this, I know you can.
> >>
> >> Umm. can you show your EXTCON config? I think you build it as module.
> >> it's tested it extcon on or not. anyway I'll test it as module and
> >> check it.
> >
> > Yes, I selected to build it as a module, which, according to your patch,
> > is a valid selection.
> 
> Found, need to add CONFIG_EXTCON_MODULE at below.

You do know we have a new macro that handles all of this for you,
IS_ENABLED().  It handles the _MODULE stuff and the other stuff as well,
and you can put it in a .c expression also.

Try using that instead.

thanks,

greg k-h
