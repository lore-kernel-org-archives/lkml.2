Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1BXQxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:53:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35275 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab1BXQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LpvGXz4QwS1dfVwv0OCLoTiqexilB3NHQvM2xafuSUX98J21D2dLe/spllEeguLzaY
         GcQ0WhN6EhatorCM3kT/4QTgs2pYTZ7Q/HEf+YQoDRmfDa+8hvWusZyG1wREhvcD4RvO
         gMe8hSSvC13EGBamcSk/4/pU/imAhldslIFDI=
Date: Thu, 24 Feb 2011 17:50:04 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20110224165004.GB15234@riccoc20.at.omicron.at>
References: <cover.1298447722.git.richard.cochran@omicron.at>
 <be1f5e801e8cd0145dd23aadae7c2055bb3c1d47.1298447722.git.richard.cochran@omicron.at>
 <20110223165058.GE14597@angua.secretlab.ca>
 <20110223112612.30071995@schlenkerla>
 <20110223175459.GH14597@angua.secretlab.ca>
 <20110223132444.65dfdda4@schlenkerla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223132444.65dfdda4@schlenkerla>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 01:24:44PM -0600, Scott Wood wrote:
> Whatever string is used should be written into a binding document.
> 
> fsl,etsec-v1.6-ptp seems like it would be just as good for that purpose.
> 
> Even just fsl,etsec-ptp will identify the binding, though it's lacking in
> identifying the hardware (in the absence of access to the eTSEC ID
> registers).

I read the conversation, and I don't mind admitting that I do not
understand what you both are arguing/discussing about.

How should I set the strings?  Like this?

arch/powerpc/boot/dts/mpc8313erdb.dts:
	ptp_clock@24E00 {
		compatible = "fsl,mpc8313-etsec-ptp";
	}
arch/powerpc/boot/dts/mpc8572ds.dts:
	ptp_clock@24E00 {
		compatible = "fsl,mpc8572-etsec-ptp";
	} 
arch/powerpc/boot/dts/p2020ds.dts:
	ptp_clock@24E00 {
		compatible = "fsl,p2020ds-etsec-ptp";
	} 
arch/powerpc/boot/dts/p2020rdb.dts:
	ptp_clock@24E00 {
		compatible = "fsl,p2020rdb-etsec-ptp";
	} 

drivers/net/gianfar_ptp.c:

static struct of_device_id match_table[] = {
	{ .compatible = "fsl,mpc8313-etsec-ptp" },
	{ .compatible = "fsl,mpc8572-etsec-ptp" },
	{ .compatible = "fsl,p2020ds-etsec-ptp" },
	{ .compatible = "fsl,p2020rdb-etsec-ptp" },
	{},
};

Please let me know if this is what you meant.

Thanks,
Richard
