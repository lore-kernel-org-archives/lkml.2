Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1LCA6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 19:58:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47672 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1LCA6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 19:58:13 -0500
MIME-Version: 1.0
In-Reply-To: <CABexPfGvJB-Fvx2SbUbJaBVouAkv3UVmmfsTpp_zE8whpHVZEw@mail.gmail.com>
References: <CABexPfGvJB-Fvx2SbUbJaBVouAkv3UVmmfsTpp_zE8whpHVZEw@mail.gmail.com>
Date: Fri, 2 Dec 2011 19:58:12 -0500
Message-ID: <CAMzpN2haQjckBGkA1ujaCD0iehAsC2S-xO7eN89S+u+FQ65zXw@mail.gmail.com>
Subject: Re: [Provisional Page Table] Why the linear address ranges starting
 both from 0 and PAGE_OFFSET are mapped to the same physical address range in
 the provisional page table?
From: Brian Gerst <brgerst@gmail.com>
To: zhihua che <zhihua.che@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 2, 2011 at 11:35 AM, zhihua che <zhihua.che@gmail.com> wrote:
> Hi, everyone
>        I know that the kernel constructs a provisional page table in
> head_32.S which maps the linear address ranges starting both from 0
> and PAGE_OFFSET to the same physical address range.  My question is
> why the linear address range starting from 0 needs to be mapped to the
> same physical address range as the leaner address range starting from
> PAGE_OFFSET does. I thought it's not necessary because the whole
> kernel (the protected mode part) is linked to the VMA PAGE_OFFSET.
>        But I found I was wrong. I'm writing a toy os which is also
> linked to VMA PAGE_OFFSET and constructs a provisional page table as
> the linux kernel does, and it works well with it. I mean it can enable
> paging successfully and continue to execute as I expect after that
> far-jump instruction. However, if I mapped only the linear address
> starting from 0xc0000000, the far-jump instructions would load random
> values to cs and eip respectfully and my os went crazy.

The identity mapping is required for the brief period between when
paging is enabled and the jump to the virtual address.  Once paging is
enabled, eip still points to the low address for the next instruction,
and the instruction fetch will cause a page fault if the identity
mapping doesn't exist.

--
Brian Gerst
