Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2JWJF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:05:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39989 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2JWJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:05:57 -0400
Subject: Re: Re: 3.7-rc2 regression : file copied to CIFS-mounted directory
 corrupted
From: Eric Dumazet <eric.dumazet@gmail.com>
To: jongman.heo@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
In-Reply-To: <33091139.64321350980240110.JavaMail.weblogic@epml04>
References: <33091139.64321350980240110.JavaMail.weblogic@epml04>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Oct 2012 11:05:52 +0200
Message-ID: <1350983152.8609.1635.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 08:17 +0000, Jongman Heo wrote:

> 
> FYI, vmxnet3 driver is used for ethernet.

Yes, this driver needs some changes

#define VMXNET3_MAX_TX_BUF_SIZE  (1 << 14)

Thats 16KB

As we can now provide up to 32KB fragments we broke something.

vmxnet3_tq_xmit() needs to split large frags into 2 parts.
(And without going to skb_linearize() of course !)

Any volunteer ?

Thanks !


