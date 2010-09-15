Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0ION2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:28:43 -0400
Received: from mail.bitdefender.com ([91.199.104.2]:57244 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0ION2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:28:41 -0400
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the usb tree
Date: Wed, 15 Sep 2010 16:21:56 +0300
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
References: <20100914125431.1603ffd1.sfr@canb.auug.org.au> <20100914040803.GB11972@kroah.com> <20100914142528.1810936b.sfr@canb.auug.org.au>
In-Reply-To: <20100914142528.1810936b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201009151621.57402.mihai.dontu@gmail.com>
X-BitDefender-Spam: No (158)
X-BitDefender-SpamStamp: v1, build 2.8.85.106941, SQMD Hits: none,
 rbl score: 0(0), bayes score: 500(0), pbayes score: 500(0), neunet
 score: 158(158), flags: [NN_EXEC_H_YAHOO_AND_GMAIL_NO_DOMAIN_KEY;
 NN_LEGIT_SUMM_400_WORDS], SQMD:
 d227cbb6f00ae9d25bfb0db7a696713c.fuzzy.fzrbl.org, total: 158(775)
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.1.0 on
 elfie.dsd.hq, sigver: 7.33890
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 September 2010 07:25:28 Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 13 Sep 2010 21:08:03 -0700 Greg KH <greg@kroah.com> wrote:
> > On Tue, Sep 14, 2010 at 12:54:31PM +1000, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > After merging the usb tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > In file included from drivers/usb/gadget/ether.c:123:
> > > drivers/usb/gadget/rndis.c: In function 'rndis_init':
> > > drivers/usb/gadget/rndis.c:1163: error: expected ';' before 'if'
> > > 
> > > Caused by commit c8feb3bad134f927a624cc19da13f57627b905e2 ("USB:
> > > gadget: rndis: fix up coding style issues in the file").
> > > 
> > > I used the version of the usb tree from next-20100913 for today.
> > 
> > I can't duplicate this at all, are you sure it's coming from my tree?
> > What is your .config here?
> 
> See above: that was an x86_64 allmodconfig build.  You need
> CONFIG_USB_GADGET_DEBUG_FILES set.
> 
> The patch above was not in your usb quilt series when I fetched it
> yesterday and it was there this morning.  The relevant hunk of the patch
> looks like this:
> 
> @@ -1160,42 +1158,40 @@ int rndis_init(void)
>  #ifdef	CONFIG_USB_GADGET_DEBUG_FILES
>  		char name [20];
> 
> -		sprintf (name, NAME_TEMPLATE, i);
> -		if (!(rndis_connect_state [i]
> -				= proc_create_data(name, 0660, NULL,
> +		sprintf(name, NAME_TEMPLATE, i);
> +		rndis_connect_state[i] = proc_create_data(name, 0660, NULL,
>  					&rndis_proc_fops,
> -					(void *)(rndis_per_dev_params + i))))
> -		{
> -			pr_debug("%s :remove entries", __func__);
> +					(void *)(rndis_per_dev_params + i))
>                                                                           
> ^ *** note missing semicolon ...
> 
> +		if (!rndis_connect_state[i]) {
> +			pr_debug("%s: remove entries", __func__);
>  			while (i) {
> -				sprintf (name, NAME_TEMPLATE, --i);
> -				remove_proc_entry (name, NULL);
> +				sprintf(name, NAME_TEMPLATE, --i);
> +				remove_proc_entry(name, NULL);
>  			}
>  			pr_debug("\n");
>  			return -EIO;

I'm to blame for that. I'm sorry. I'll do an allmodconfig too, next time 
(besides being extra careful).

Thanks,

-- 
Mihai Donțu
