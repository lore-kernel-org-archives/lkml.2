Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab1DMANK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:13:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59375 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab1DMANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:13:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: mm: convert vma->vm_flags to 64bit
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <1302646024.28876.52.camel@pasglop>
References: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com> <1302646024.28876.52.camel@pasglop>
Message-Id: <20110413091301.41E1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 09:13:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2011-04-12 at 14:06 +0300, Alexey Dobriyan wrote:
> > On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > After next year? All developers don't have to ignore compiler warnings!
> > 
> > At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.
> > 
> > VM_SAO is ppc64 only, so it could be moved into high part,
> > freeing 1 bit?
> 
> My original series did use a type, I don't know what that was dropped,
> it made conversion easier imho.

Yes, I take Hugh's version because vm_flags_t is ugly to me. And arch 
dependent variable size is problematic. Because Almost all driver developers
only test their code on x86. Also, I don't want to add hidden ifdef into mm
code.

Thanks.


