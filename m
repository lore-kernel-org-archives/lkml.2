Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab0HLMtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:49:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48683 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0HLMtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I2JHL64DbMMDQcwNZ5reIs4GUrmquNBm2Zwn7ixFhmMGPuM7oOj0ZvraPCdfz//3uz
         RD5fZEDup0qxnIQ+9EK3qBdoewsulk/KNJ3BAdPSFSub5xkRe9x6Z7XdK5n80rSo/Hob
         Vy8bQ+Lx7ucTO5v+R4U3/M6Wbyv9CPPTbCVL0=
Date: Thu, 12 Aug 2010 16:48:13 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@web.de>
Subject: Re: batman-adv: design suggestions
Message-ID: <20100812124813.GB4881@albatros>
References: <20100809203403.GA16183@albatros>
 <201008092254.39960.sven.eckelmann@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008092254.39960.sven.eckelmann@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 22:53 +0200, Sven Eckelmann wrote:
> Vasiliy Kulikov wrote:
> > 1) Some incoming packets may cause a storm of error logs, such as at
> > routing.c:862
> > 
> > 
> > 	if (icmp_packet->msg_type != ECHO_REQUEST) {
> > 		pr_warning("Warning - can't forward icmp packet from %pM to "
> > 			   "%pM: ttl exceeded\n", icmp_packet->orig,
> > 			   icmp_packet->dst);
> > 
> >   Any flooding bad guy is able to fill our disks with logs.
> >   This should be logged only at some slow rate (e.g. 5 logs/sec) or as
> >   pr_debug().
> 
> Correct. So you would prefer pr_warn_ratelimited?

As I see in net/, such packets should be silently dropped with
drop_count++. Exceeded TTL is rather common situation and is not critical.
Also such buggy packets should be found out & dropped as fast as possible.
So IMO it should be debug output (if any) that does no overhead at nodebug
compilation.


3) Also there is no handler of online MTU change, at hard_if_event().


Is there any (un)official documentation/RFC/whatever of batman-adv
protocol? I found only expired RFC of batman that is using UDP at 
www.open-mesh.org.


Thanks,
Vasiliy.
