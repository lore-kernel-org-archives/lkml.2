Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2HWNAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:00:37 -0400
Received: from nm24-vm5.bullet.mail.ird.yahoo.com ([212.82.109.196]:34989 "HELO
	nm24-vm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758492Ab2HWNAc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:00:32 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 09:00:31 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 897873.6520.bm@omp1035.mail.ird.yahoo.com
X-YMail-OSG: IyefiTUVM1lvmGjBdSbjcCTEogNTAaCprRxD1BMNWlyfPij
 7MfkLq_u8E8ETPc.1NtwkWJ7BlUHeawsZxd12Qxd0hzMFs_c4CNfroYS14Bg
 2qGunAPl5fan8.d8XCUX.xUtBtE4J_bof1KnacyeDL7ruql4A1WeV9UAdsir
 oizueVvfK0n34QXCoKG82tM7e6REcQbvwAdQzw7bZu5EOfZn4sodbPv3nlsw
 VRttQXtLi_GBYSr.O0t_amPN2uxzqSZ60DnZjrVHDZ0Q0oHd_c7afRRdG5KZ
 GUoOc02b18_AqS0HNNFGCt7ltuzCCO7y57ThnMFC8LicykwB.gvdUflaCRFf
 pG2fBtZrmiNdPVezpTd8CCvbAGAiwAm65Uth.TYkjZeH2Ke9FKn0x_Ua4VMK
 hVB_0LnG.e._7ck5SSMGDZocEwL.5vvRlxTNaRnZrLrQFtiFjEyk-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/15.0.8 YahooMailWebService/0.8.121.416
Message-ID: <1345726463.82057.YahooMailClassic@web29403.mail.ird.yahoo.com>
Date: Thu, 23 Aug 2012 13:54:23 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without DEBUG
To: Antti Palosaari <crope@iki.fi>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <5034F8E3.2060700@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 22/8/12, Antti Palosaari <crope@iki.fi> wrote:

> On 08/22/2012 04:57 PM, Hin-Tak Leung
> wrote:
> > Antti Palosaari wrote:
> >> Hello Hiroshi,
> >>
> >> On 08/21/2012 10:02 AM, Hiroshi Doyu wrote:
> >>> Antti Palosaari <crope@iki.fi>
> wrote @ Mon, 20 Aug 2012 23:29:34 +0200:
> >>>
> >>>> On 08/20/2012 02:14 PM, Hiroshi Doyu
> wrote:
> >>>>> Hi Antti,
> >>>>>
> >>>>> Antti Palosaari <crope@iki.fi>
> wrote @ Sat, 18 Aug 2012 02:11:56
> >>>>> +0200:
> >>>>>
> >>>>>> On 08/17/2012 09:04 AM, Hiroshi
> Doyu wrote:
> >>>>>>> dev_dbg_reatelimited() without
> DEBUG printed "217078 callbacks
> >>>>>>> suppressed". This shouldn't
> print anything without DEBUG.
> >>>>>>>
> >>>>>>> Signed-off-by: Hiroshi Doyu
> <hdoyu@nvidia.com>
> >>>>>>> Reported-by: Antti Palosaari
> <crope@iki.fi>
> >>>>>>> ---
> >>>>>>> 
>    include/linux/device.h |    6
> +++++-
> >>>>>>>     1 files
> changed, 5 insertions(+), 1 deletions(-)
> >>>>>>>
> >>>>>>> diff --git
> a/include/linux/device.h b/include/linux/device.h
> >>>>>>> index eb945e1..d4dc26e 100644
> >>>>>>> --- a/include/linux/device.h
> >>>>>>> +++ b/include/linux/device.h
> >>>>>>> @@ -962,9 +962,13 @@ do { 
>                
>                
>   \
> >>>>>>>     
>    dev_level_ratelimited(dev_notice, dev,
> fmt, ##__VA_ARGS__)
> >>>>>>>     #define
> dev_info_ratelimited(dev, fmt, ...)     
>           \
> >>>>>>>     
>    dev_level_ratelimited(dev_info, dev, fmt,
> ##__VA_ARGS__)
> >>>>>>> +#if defined(DEBUG)
> >>>>>>>     #define
> dev_dbg_ratelimited(dev, fmt, ...)     
>           \
> >>>>>>>     
>    dev_level_ratelimited(dev_dbg, dev, fmt,
> ##__VA_ARGS__)
> >>>>>>> -
> >>>>>>> +#else
> >>>>>>> +#define
> dev_dbg_ratelimited(dev, fmt, ...)     
>       \
> >>>>>>> +   
> no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> >>>>>>> +#endif
> >>>>>>>     /*
> >>>>>>>      * Stupid
> hackaround for existing uses of non-printk uses
> >>>>>>> dev_info
> >>>>>>>      *
> >>>>>>>
> >>>>>>
> >>>>>> NACK. I don't think that's correct
> behavior. After that patch it
> >>>>>> kills
> >>>>>> all output of
> dev_dbg_ratelimited(). If I use dynamic debugs and
> >>>>>> order
> >>>>>> debugs, I expect to see debugs as
> earlier.
> >>>>>
> >>>>> You are right. I attached the update
> patch, just moving *_ratelimited
> >>>>> functions after dev_dbg() definitions.
> >>>>>
> >>>>> With DEBUG defined/undefined in your
> "test.ko", it works fine. With
> >>>>> CONFIG_DYNAMIC_DEBUG, it works with
> "+p", but with "-p", still
> >>>>> "..callbacks suppressed" is printed.
> >>>>
> >>>> I am using dynamic debugs and behavior is
> now just same as it was when
> >>>> reported that bug. OK, likely for static
> debug it is now correct.
> >>>
> >>> The following patch can also refrain
> "..callbacks suppressed" with
> >>> "-p". I think that it's ok for all cases.
> >>>
> >>>> From
> b4c6aa9160f03b61ed17975c73db36c983a48927 Mon Sep 17 00:00:00
> 2001
> >>> From: Hiroshi Doyu <hdoyu@nvidia.com>
> >>> Date: Mon, 20 Aug 2012 13:49:19 +0300
> >>> Subject: [v3 1/1] driver-core: Shut up
> dev_dbg_reatelimited() without
> >>> DEBUG
> >>>
> >>> dev_dbg_reatelimited() without DEBUG printed
> "217078 callbacks
> >>> suppressed". This shouldn't print anything
> without DEBUG.
> >>>
> >>> With CONFIG_DYNAMIC_DEBUG, the print should be
> configured as expected.
> >>>
> >>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> >>> Reported-by: Antti Palosaari <crope@iki.fi>
> >>> ---
> >>>   include/linux/device.h
> |   62
> >>>
> +++++++++++++++++++++++++++++------------------
> >>>   1 files changed, 38
> insertions(+), 24 deletions(-)
> >>>
> >>> diff --git a/include/linux/device.h
> b/include/linux/device.h
> >>> index 9648331..bb6ffcb 100644
> >>> --- a/include/linux/device.h
> >>> +++ b/include/linux/device.h
> >>> @@ -932,6 +932,32 @@ int _dev_info(const struct
> device *dev, const
> >>> char *fmt,
> >>> ...)
> >>>
> >>>   #endif
> >>>
> >>> +/*
> >>> + * Stupid hackaround for existing uses of
> non-printk uses dev_info
> >>> + *
> >>> + * Note that the definition of dev_info below
> is actually _dev_info
> >>> + * and a macro is used to avoid redefining
> dev_info
> >>> + */
> >>> +
> >>> +#define dev_info(dev, fmt, arg...)
> _dev_info(dev, fmt, ##arg)
> >>> +
> >>> +#if defined(CONFIG_DYNAMIC_DEBUG)
> >>> +#define dev_dbg(dev, format, ...)   
>          \
> >>> +do {           
>              
>    \
> >>> +    dynamic_dev_dbg(dev, format,
> ##__VA_ARGS__); \
> >>> +} while (0)
> >>> +#elif defined(DEBUG)
> >>> +#define dev_dbg(dev, format, arg...) 
>       \
> >>> +    dev_printk(KERN_DEBUG, dev,
> format, ##arg)
> >>> +#else
> >>> +#define dev_dbg(dev, format, arg...) 
>               \
> >>> +({           
>                
>     \
> >>> +    if (0)     
>                
>       \
> >>> +       
> dev_printk(KERN_DEBUG, dev, format, ##arg);    \
> >>> +    0;       
>                
>     \
> >>> +})
> >>> +#endif
> >>> +
> >>>   #define
> dev_level_ratelimited(dev_level, dev, fmt, ...)   
>         \
> >>>   do {     
>                
>               \
> >>>       static
> DEFINE_RATELIMIT_STATE(_rs,       
>         \
> >>> @@ -955,33 +981,21 @@ do {     
>                
>               \
> >>>   
>    dev_level_ratelimited(dev_notice, dev,
> fmt, ##__VA_ARGS__)
> >>>   #define
> dev_info_ratelimited(dev, fmt, ...)     
>           \
> >>>   
>    dev_level_ratelimited(dev_info, dev, fmt,
> ##__VA_ARGS__)
> >>> +#if defined(CONFIG_DYNAMIC_DEBUG) ||
> defined(DEBUG)
> >>>   #define
> dev_dbg_ratelimited(dev, fmt, ...)     
>           \
> >>> -    dev_level_ratelimited(dev_dbg,
> dev, fmt, ##__VA_ARGS__)
> >>> -
> >>> -/*
> >>> - * Stupid hackaround for existing uses of
> non-printk uses dev_info
> >>> - *
> >>> - * Note that the definition of dev_info below
> is actually _dev_info
> >>> - * and a macro is used to avoid redefining
> dev_info
> >>> - */
> >>> -
> >>> -#define dev_info(dev, fmt, arg...)
> _dev_info(dev, fmt, ##arg)
> >>> -
> >>> -#if defined(CONFIG_DYNAMIC_DEBUG)
> >>> -#define dev_dbg(dev, format, ...)   
>          \
> >>> -do {           
>              
>    \
> >>> -    dynamic_dev_dbg(dev, format,
> ##__VA_ARGS__); \
> >>> +do {           
>                
>         \
> >>> +    static
> DEFINE_RATELIMIT_STATE(_rs,       
>         \
> >>> +           
>          
> DEFAULT_RATELIMIT_INTERVAL,    \
> >>> +           
>          
> DEFAULT_RATELIMIT_BURST);        \
> >>> +   
> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);   
>         \
> >>> +    if (unlikely(descriptor.flags
> & _DPRINTK_FLAGS_PRINT) &&    \
> >>> +       
> __ratelimit(&_rs))         
>               \
> >>> +       
> __dynamic_pr_debug(&descriptor, pr_fmt(fmt), 
>       \
> >>> +           
>        ##__VA_ARGS__);   
>         \
> >>>   } while (0)
> >>> -#elif defined(DEBUG)
> >>> -#define dev_dbg(dev, format, arg...) 
>       \
> >>> -    dev_printk(KERN_DEBUG, dev,
> format, ##arg)
> >>>   #else
> >>> -#define dev_dbg(dev, format, arg...) 
>               \
> >>> -({           
>                
>     \
> >>> -    if (0)     
>                
>       \
> >>> -       
> dev_printk(KERN_DEBUG, dev, format, ##arg);    \
> >>> -    0;       
>                
>     \
> >>> -})
> >>> +#define dev_dbg_ratelimited(dev, fmt,
> ...)            \
> >>> +    no_printk(KERN_DEBUG
> pr_fmt(fmt), ##__VA_ARGS__)
> >>>   #endif
> >>>
> >>>   #ifdef VERBOSE_DEBUG
> >>
> >> That seems to work correctly now. I tested it using
> dynamic debugs. It
> >> was
> >> Hin-Tak who originally reported that bug for me
> after I added few
> >> ratelimited
> >> debugs for DVB stack. Thank you!
> >>
> >> Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> >> Tested-by: Antti Palosaari <crope@iki.fi>
> >>
> >>
> >> regards
> >> Antti
> >>
> >
> > This is with mediatree/for_v3.7-8 , playing DVB-T video
> with mplayer.
> >
> > echo 'file ...media_build/v4l/usb_urb.c +p' >
> > /sys/kernel/debug/dynamic_debug/control
> >
> > With +p
> >
> > [137749.698202] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137749.699449] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137749.700825] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.690862] usb_urb_complete: 3570 callbacks
> suppressed
> > [137754.690888] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.692489] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.693745] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.694882] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.696240] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.697483] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.699002] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.700884] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.701613] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137754.702986] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137759.695906] usb_urb_complete: 3595 callbacks
> suppressed
> > [137759.695934] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137759.697788] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> > [137759.698772] usb 1-3: usb_urb_complete: bulk urb
> completed status=0
> > length=4096/4096 pack_num=0 errors=0
> >
> > with -p
> >
> > [137814.730303] usb_urb_complete: 3555 callbacks
> suppressed
> > [137819.740698] usb_urb_complete: 3519 callbacks
> suppressed
> > [137824.744857] usb_urb_complete: 3443 callbacks
> suppressed
> > [137829.746023] usb_urb_complete: 3345 callbacks
> suppressed
> > [137834.749931] usb_urb_complete: 3558 callbacks
> suppressed
> > [137839.753102] usb_urb_complete: 3465 callbacks
> suppressed
> > [137844.755521] usb_urb_complete: 3438 callbacks
> suppressed
> 
> I think you are using media_build.git (with my devel tree)?
> Could that 
> be due to that as there is some compat stuff? I am not very
> familiar 
> with media_build.git...

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Yes, sorry about that. media_build is picking up the system's kernel header, I think - dev_dbg_ratelimited is defined in the older kernel 3.5.x's include/linux/device.h .

Yes, it was me who first noticed the problem (when DVB-usb started using the define).
