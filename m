Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1AFKfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:35:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1AFKfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:35:54 -0500
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1294308645-31113-3-git-send-email-zamsden@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <F57C0733-9A1A-4A6D-9D62-39B836559878@suse.de>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8C148)
From: Alexander Graf <agraf@suse.de>
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
Date: Thu, 6 Jan 2011 11:34:43 +0100
To: Zachary Amsden <zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 06.01.2011 um 11:10 schrieb Zachary Amsden <zamsden@redhat.com>:

> Use an MSR to allow "soft" migration to hosts which do not support
> TSC trapping.  Rather than make this a required element of any
> migration protocol, we allow the TSC rate to be exported as a data
> field (useful in its own right), but we also allow a one time write
> of the MSR during VM creation.  The result is that for the common
> use case, no protocol change is required to communicate TSC rate
> to the receiving host.
> 
> This allows administrative tools to configure migration policy
> as they see appropriate.  Rather than dictate this policy with the
> KVM implementation, we properly allow migration to hosts which both
> do and do not support setting of the TSC rate on the receiving end.
> If it is wished to not support migration to a host which lacks
> support for the TSC rate feature, that can be coordinated externally.

Isn't there a real hw equivalent of such a register? It might make more sense to just implement that then.


Alex

> 
