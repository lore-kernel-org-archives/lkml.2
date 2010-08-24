Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0HXWUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:20:53 -0400
Received: from mail.solarflare.com ([216.237.3.220]:17953 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab0HXWUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:20:51 -0400
Subject: Re: RFC: MTU for serving NFS on Infiniband
From: Ben Hutchings <bhutchings@solarflare.com>
To: Marc Aurele La France <tsi@ualberta.ca>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
	 <20100823080543.319143e3@nehalam>
	 <alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca>
	 <1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
	 <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 24 Aug 2010 23:20:41 +0100
Message-ID: <1282688441.22839.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Aug 2010 22:24:26.0777 (UTC) FILETIME=[1CA69890:01CB43DB]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17590.005
X-TM-AS-Result: No--27.001400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 13:49 -0600, Marc Aurele La France wrote:
> On Tue, 24 Aug 2010, Ben Hutchings wrote:
> > On Tue, 2010-08-24 at 09:14 -0600, Marc Aurele La France wrote:
> >> On Mon, 23 Aug 2010, Stephen Hemminger wrote:
> >>> On Mon, 23 Aug 2010 08:44:37 -0600 (MDT)
> >>> Marc Aurele La France <tsi@ualberta.ca> wrote:
> >>>> In regrouping for my next tack at this, I noticed that all stack traces go
> >>>> through ip_append_data().  This would be ipv6_append_data() in the IPv6 case.
> >>>> A _very_ rough draft that would have ip_append_data() temporarily drop down
> >>>> to a smaller fake MTU follows ...
> 
> >>> Why doesn't NFS generate page size fragments?  Does Infiniband or your
> >>> device not support this?  Any thing that requires higher order allocation
> >>> is going to unstable under load.  Let's fix the cause not the apply bandaid
> >>> solution to the symptom.
> 
> >> From what I can tell, IP fragmentation is done centrally.
> > [...]
> 
> > Stephen and I are not talking about IP fragmentation, but about the
> > ability to append 'fragments' to an skb rather than putting the entire
> > packet payload in a linear buffer.  See
> > <http://vger.kernel.org/~davem/skb_data.html>.
> 
> Any payload has to either fit in the MTU, or has to be broken up into 
> MTU-sized (or less) fragments, come hell or high water.  That this is done 
> centrally is a good thing.

Not necessarily.  Offloading it to hardware, where possible, is usually
a performance win.

> It is the "(or less)" part that I am working towards here.

The inability to allocate large linear buffers is not a good reason to
generate packets smaller than the MTU.  You are working around the real
problem.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

