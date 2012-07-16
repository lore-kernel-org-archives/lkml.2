Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2GPPdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:33:07 -0400
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:48526 "EHLO
	smtp5.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2GPPdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:33:04 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2012 11:33:04 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp5.sgsi.ucl.ac.be 8ADC011E0F3
From: Christoph Paasch <christoph.paasch@uclouvain.be>
To: Piotr Sawuk <a9702387@unet.univie.ac.at>
Reply-To: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: resurrecting tcphealth
Date: Mon, 16 Jul 2012 17:24:37 +0200
Message-ID: <1648678.899sL4YBmA@cpaasch-mac>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6k=?= Catholique de Louvain
User-Agent: KMail/4.8.4 (Linux/3.2.0-27-mptcp; KDE/4.8.4; x86_64; ; )
In-Reply-To: <436a23ea8f8df4e8e3c71c369f1e3649.squirrel@webmail.univie.ac.at>
References: <cc6495b92f1df180c1ad43057ceb0b98.squirrel@webmail.univie.ac.at> <1342445557.2523.8.camel@bwh-desktop.uk.solarflarecom.com> <436a23ea8f8df4e8e3c71c369f1e3649.squirrel@webmail.univie.ac.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 8ADC011E0F3.A100D
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2012 17:12:26 Piotr Sawuk wrote:
> +               seq_printf(seq, "%d: %-21pI4:%u %-21pI4:%u "
> +                               "%8u %8lu %8lu %8lu %8lu%n",
> +                               st->num,
> +                               &inet->inet_rcv_saddr,
> +                               ntohs(inet->inet_sport),
> +                               &inet->inet_daddr,
> +                               ntohs(inet->inet_dport),
> +                               jiffies_to_msecs(tp->srtt),

This still doesn't gives you the correct RTT.
srtt is in jiffies * 8.

You should do jiffies_to_msecs(tp->srtt) >> 3.

The RTT is already exposed by tcp_info anyway... (see tcp_get_info() - where 
you also see the bitshift)


Christoph

-- 
IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://mptcp.info.ucl.ac.be
Université Catholique de Louvain
--
