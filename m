Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab2JWJUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:20:20 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:54508 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756925Ab2JWJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:20:19 -0400
Date: Tue, 23 Oct 2012 02:20:18 -0700 (PDT)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        "VMware, Inc." <pv-drivers@vmware.com>,
        jongman heo <jongman.heo@samsung.com>
Message-ID: <636804155.6539897.1350984018386.JavaMail.root@vmware.com>
In-Reply-To: <1350983152.8609.1635.camel@edumazet-glaptop>
Subject: Re: 3.7-rc2 regression : file copied to CIFS-mounted directory
 corrupted
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, thanks for the note. I will submit a patch to do it.

Shreyas

----- Original Message -----
> On Tue, 2012-10-23 at 08:17 +0000, Jongman Heo wrote:
> 
> > 
> > FYI, vmxnet3 driver is used for ethernet.
> 
> Yes, this driver needs some changes
> 
> #define VMXNET3_MAX_TX_BUF_SIZE  (1 << 14)
> 
> Thats 16KB
> 
> As we can now provide up to 32KB fragments we broke something.
> 
> vmxnet3_tq_xmit() needs to split large frags into 2 parts.
> (And without going to skb_linearize() of course !)
> 
> Any volunteer ?
> 
> Thanks !
> 
> 
> 
