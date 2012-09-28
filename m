Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2I1H42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:56:28 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60932 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab2I1H41 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 28 Sep 2012 03:56:27 -0400
Message-Id: <50657462020000780009E64A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 28 Sep 2012 08:56:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <andrew.cooper3@citrix.com>, "xen-devel" <xen-devel@lists.xen.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/11] x86/kexec: Add extra pointers to transition
 page table PGD, PUD, PMD and PTE
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Some implementations (e.g. Xen PVOPS) could not use part of identity page 
> table
> to construct transition page table. It means that they require separate 
> PUDs,
> PMDs and PTEs for virtual and physical (identity) mapping. To satisfy that
> requirement add extra pointer to PGD, PUD, PMD and PTE and align existing 
> code.

I'm puzzled by this - why would you need to reintroduce what had
been dropped a long time ago, when the forward ported kernels
don't need it? Xen itself doesn't need the extra entries, their
presence is purely a requirement of the specific kernel
implementation afaict.

Jan

