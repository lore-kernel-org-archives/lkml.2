Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0EZPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:16:58 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:48526 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756033Ab0EZPQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:16:56 -0400
Date: Wed, 26 May 2010 11:16:51 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: =?iso-8859-1?Q?S=E9bastien?= Paumier 
	<sebastien.paumier@univ-mlv.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: getpid() returning same value as getppid()
Message-ID: <20100526151651.GA21197@elliptictech.com>
Mail-Followup-To: =?iso-8859-1?Q?S=E9bastien?= Paumier <sebastien.paumier@univ-mlv.fr>,
	linux-kernel@vger.kernel.org
References: <4BFD33F0.1060908@univ-mlv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BFD33F0.1060908@univ-mlv.fr>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:45 Wed 26 May     , Sébastien Paumier wrote:
> Hi,
> here is a bug that occurs on my kernel 2.6.31-21, maybe with older ones. 
>   If a C program contains a function with the constructor attribute that 
> calls getpid(), then, a call to syscall(SYS_fork) produces a son that 
> obtains the same value calling getpid() or getppid().

The GNU C library caches the results of getpid, which is probably the
cause of your grief.  This cache relies on the glibc wrappers for fork
and friends, which you have bypassed by using syscall directly.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
