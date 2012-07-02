Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab2GBEhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:37:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48897 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2GBEhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:37:36 -0400
X-AuditID: cbfee60b-b7f866d00000631c-71-4ff1258c3732
Date: Mon, 02 Jul 2012 04:37:32 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona class
 devices
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120702041908894@myungjoo.ham
Msgkey: 20120702041908894@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120702041908894@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <23829569.63411341203851815.JavaMail.weblogic@epml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tmbo9qh/9DR7/k7G4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZDcs+sxcsUqu43OzfwLhAtYuRk0NIQF1i0ZKTbCC2hICJxLSm
	18wQtpjEhXvrgeJcQDXzGSUO7PwOVsQioCKxe/4mxi5GDg42AT2JmZ+TQcLCAmESzdPfgZWI
	CJhJPPr/nx2kl1ngMJPEzbNrGSGWKUms2feKBcTmFRCUODnzCQvEMlWJX33dUHE1iecHTzFC
	xCUkZk2/wAph80rMaH8KVS8nMe3rGqhDpSXOz9rACHP04u+PoeL8Esdu72ACuROk98n9YJgx
	uzd/gfpXQGLqmYNQrVoS7zpboOJ8EmsWvmWBGbPr1HJmmN77W+YygdjMAooSU7ofskPYWhJf
	fuxjQ/cWr4CjxKT9J1kmMMrNQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelpxrqFSfmFpfmpesl
	5+duYgRH+TPuHYyzGiwOMQpwMCrx8J5X/ugvxJpYVlyZe4hRgoNZSYT36fH3/kK8KYmVValF
	+fFFpTmpxYcYpTlYlMR5J1lf8BcSSE8sSc1OTS1ILYLJMnFwSjUwtp7aceTskQwrj/2pxV9u
	H7n/pMz+hcKUPSsPqt1LlTl2z679ydqT1c+XWO6I/8wqFv1MteB7cuJfNsZLP8t2+svt/21y
	0ETb/L/V4ntepk8fOe+ZuOlHlcbNtQ/UAhdzfH/QZHlooc3EqbrzVjxnd3yfbxAoJ7ovecM8
	lbhpWs/kVjx2/8V5skiJpTgj0VCLuag4EQClo88F7gIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q624bhGk006903

On Thu, Jun 28, 2012 at 02:08:10AM +0000, MyungJoo Ham wrote:
> 
> > I only have some performance concerns that may be ignored
> > if you don't care of it for this device.
> 
> To be honest I think if we ever care about performance with extcon we've
> got a serious problem - cable insertion shouldn't be happening too
> quickly and obviously the userspace API has all the same issues.

Yes.. the performance part was not a serious concern (so it may be ignored
for now).

The only "real" concern was the cable name part and I'll add a patch
fixing related drivers (including this) after fixing the class file.


Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>


I'll put this to git
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next
after testing with the MFD part of Arizona drivers.

Thanks



MyungJoo.

> 
> > > +#define ARIZONA_CABLE_MECHANICAL "Mechanical"
> > > +#define ARIZONA_CABLE_HEADPHONE  "Headphone"
> > > +#define ARIZONA_CABLE_HEADSET    "Headset"
> 
> > > +static const char *arizona_cable[] = {
> > > +	ARIZONA_CABLE_MECHANICAL,
> > > +	ARIZONA_CABLE_HEADSET,
> > > +	ARIZONA_CABLE_HEADPHONE,
> > > +	NULL,
> > > +};
> 
> > For ARIZONA_CABLE_HEADPHONE and ARIZONA_CABLE_MECHANICAL, you can
> > use extcon_cable_name[EXTCON_HEADPHONE_OUT] and
> > extcon_cable_name[EXTCON_MECHANICAL].
> 
> > It appears that I need to rephrase line 38-41 of extcon_class.c. Anyway,
> > it is not recommended to import the whole list. However, it is strongly
> > recommended to reuse the corresponding entries from the list.
> 
> That's what I initially wanted to do but there's real usability problems
> fishing the values out of the array, the obvious method does things like
> this:
> 
> drivers/extcon/extcon-arizona.c:62: error: initializer element is not constant
> drivers/extcon/extcon-arizona.c:62: error: (near initialization for 'arizona_cable[0]')
> 
> for example and you don't want the driver to end up looking like line
> noise.  Perhaps there's some simple way of doing it that didn't occur to
> me but there aren't any examples in tree.

Hmm... ok. I'll fix it and apply to corresponding drivers later.

> 
> > Anyway, the HEADSET appears to be a pair of HEADPHONE and MIC.
> > You may replace HEADSET with MIC in arizona_cable and remove exclusive[]
> > and regard HEADPHONE | MIC as "HEADSET".
> 
> This was done following the example of the Android switch API which
> defines these as separate cable types.  Cable type is probably the wrong
> name here but it's a bit late now...
> 
> > > +	/* If we got a high impedence we should have a headset, report it. */
> > > +	if (info->detecting && (val & 0x400)) {
> > > +		ret = extcon_set_cable_state(&info->edev,
> > > +					     ARIZONA_CABLE_HEADSET, true);
> 
> > You may use extcon_set_cable_state_ for the performance
> > as you already know the index of HEADSET. Or extcon_update_state();
> 
> I didn't use set_cable_state_ as the _ makes it look like
> extcon_set_cable_state() is the intended call, obviously almost every
> driver will have the indexes known.  If there's much preferenced here
> I'd expect the main function to take the numbers as argument and then
> have extcon_set_cable_state_by_name() or something.
> 
> extcon_update_state() is a bit annoying to use as you need defines for
> both indexes and bits or you need shifting so the code looks ugly.  

Whichever is fine. This is not a critical part.

> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
