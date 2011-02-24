Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1BXQlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:41:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57069 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab1BXQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gtR3sYbuEHeqw/0bApVgIzBOMHGqRR4XKDTFAkS8q8UavNgBnitWf249G8FzHzi7g2
         COdOUJGSE19g0qUOdWlENa+moUp4z39Ojy7IITcZND2Dk6GuSa3SP70JDG7jKaLccLSq
         xKELzviAWtVN8IL7w4MOMVhedu+0pR0aF7wU8=
Date: Thu, 24 Feb 2011 17:39:44 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Scott Wood <scottwood@freescale.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>, Christoph Lameter <cl@linux.com>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH V11 2/4] ptp: Added a clock that uses the eTSEC found
 on the MPC85xx.
Message-ID: <20110224163944.GA15234@riccoc20.at.omicron.at>
References: <cover.1298447722.git.richard.cochran@omicron.at>
 <be1f5e801e8cd0145dd23aadae7c2055bb3c1d47.1298447722.git.richard.cochran@omicron.at>
 <20110223165058.GE14597@angua.secretlab.ca>
 <20110223112612.30071995@schlenkerla>
 <20110223175459.GH14597@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223175459.GH14597@angua.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 10:54:59AM -0700, Grant Likely wrote:
> On Wed, Feb 23, 2011 at 11:26:12AM -0600, Scott Wood wrote:

> > The eTSEC revision is probeable as well, but due the way PTP is described as
> > a separate node, the driver doesn't have straightforward access to those
> > registers.
> 
> Ignorant question: Should the ptp be described as a separate node?

Well, the PTP Hardware Clock function is logically separate from the
MAC function. PHCs can be implemented in the MAC, in the PHY, or in
between in an FPGA on MII bus.

If the PHC is in the MAC, then it might be wise to implement one
driver that offers both the MAC and the PHC.

In the case of gianfar, it is not really necessary to combine the PHC
into the gianfar driver, since the registers are pretty well
separated. Also, given the size and complexity (and churn over time)
of the gianfar driver, I decided to keep the PHC separate.

Right now, the driver correctly handles all the clock revisions in the
boards that I have (mpc8313, mpc8572, p2020ds, p2020rdb).

If checking the revision becomes important, then we can always export
a function from gianfar to provide this.

Thanks,

Richard
