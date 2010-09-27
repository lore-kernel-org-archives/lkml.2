Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab0I0JWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:22:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab0I0JWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:22:51 -0400
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4CA06147.7080805@redhat.com>
Date: Mon, 27 Sep 2010 11:22:49 +0200
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C725B379-9631-46E4-A825-E43A5120681E@suse.de>
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <4CA057EA.7000609@redhat.com> <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de> <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de> <4CA06147.7080805@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27.09.2010, at 11:17, Avi Kivity wrote:

> On 09/27/2010 11:15 AM, Alexander Graf wrote:
>> >
>> >  Wow, this is incredibly ugly :). Can't we just mask NMIs when the interrupt shadow is active?
> 
> I plan to do that, for all the code that's out there relying on on STI interrupt shadow masking NMIs.
> 
>> Yeah, that's me writing without thinking. So this means that the race can also happen on real hardware?
>> 
> 
> Yes.  At least on documented hardware.  Some (most? all?) hardware does mask NMIs after STI.

If all hardware masks NMIs after STI, wouldn't it be better to update the spec and declare KVM buggy for injecting NMIs there?


Alex

