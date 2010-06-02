Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0FBQ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:59:21 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:46081 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205Ab0FBQ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:59:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [Bug 16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
Date: Wed, 2 Jun 2010 10:58:56 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
References: <4BF40014.30303@ntlworld.com> <4BF48425.2040702@oracle.com> <201005201108.07040.bjorn.helgaas@hp.com>
In-Reply-To: <201005201108.07040.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021058.57361.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the basic problem is that Yinghai's patch broke your system,
and this is a regression between 2.6.33 and 2.6.34.

We could use a quirk like yours (which looks fine, BTW) to cover up
this regression, but I don't like that approach because other machines
are probably affected by the same issue, and we'd have to find and
fix them one-by-one.

I think it'd be better to figure out the problem with 3e3da00c01d
and fix or revert it.  I said earlier that I wasn't in favor of just
reverting it, and I still don't like that option because it will
likely break something.  But Yinghai didn't supply any details about
the system that 3e3da00c01d fixed, so I don't know how to fix things
so both that system and yours work.

I assume that 2.6.34 with 3e3da00c01d reverted will work fine even
without "pci=use_crs".  Can you try that and attach the dmesg log?
