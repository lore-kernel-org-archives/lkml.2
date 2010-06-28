Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0F1KGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:06:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab0F1KGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:06:12 -0400
Message-ID: <4C287332.5080803@cn.fujitsu.com>
Date: Mon, 28 Jun 2010 18:02:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com>
In-Reply-To: <4C287081.40300@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

> 
> Instead of adding a new bit, can you encode the protection in the direct
> sp's access bits?  So we'll have one sp for read-only or
> writeable-but-not-dirty small pages, and another sp for
> writeable-and-dirty small pages.
> 

It looks like it can't solve all problems, it fix the access corrupted,
but will cause D bit losed:

mapping A and mapping B both are writable-and-dirty, when mapping A write
#PF occurs, the mapping is writable, then we can't set B's D bit anymore.

Anyway, i think we should re-intall the mapping when the state is changed. :-(
