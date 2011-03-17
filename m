Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1CQW3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:29:06 -0400
Received: from sysmic.org ([88.191.45.54]:56858 "EHLO draco.sysmic.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab1CQW3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:29:04 -0400
From: =?iso-8859-1?q?J=E9r=F4me_Pouiller?= <jerome@sysmic.org>
To: Aneesh Bhasin <contact.aneesh@gmail.com>
Subject: Re: smap output - unnamed entries and heap
Date: Thu, 17 Mar 2011 23:22:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-28-generic; KDE/4.5.3; x86_64; ; )
Cc: =?iso-8859-1?q?P=E1draig_Brady?= <P@draigbrady.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-newbie" <linux-newbie@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <AANLkTik3N5j74eWastminNZLevPqoSCEiVCrX1vP66_k@mail.gmail.com> <4D80C47C.80300@draigBrady.com> <AANLkTi=gN=DOU9bQtqdr1s44y5QgLn0W9_oRb9JTMWNa@mail.gmail.com>
In-Reply-To: <AANLkTi=gN=DOU9bQtqdr1s44y5QgLn0W9_oRb9JTMWNa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103172322.49055.jerome@sysmic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011 12:46:13 Aneesh Bhasin wrote:
[..]
> However, as I wrote earlier, there a lot of anonymous memory regions
> listed in smap output (with permission rwxp) - and I do not know of
> any way in which I could associate these memory mapping to a
> particular library..
A few years ago, I had a similar need. I made a small library which overload 
malloc (and free) and display caller (using backtrace_symbols function). 
Next I loaded it using LD_PRELOAD. The main problems are :
  * it only work for malloced memory (not mmaped memory)
  * It is difficult to interpred efficiently information provided. Name of 
caller may not be sufficient to understand why memory is allocated.

--
Jérôme Pouiller <jezz@sysmic.org>
