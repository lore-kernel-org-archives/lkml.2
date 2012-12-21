Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab2LUG7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 01:59:04 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:44621 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LUG6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 01:58:55 -0500
MIME-Version: 1.0
Date: Fri, 21 Dec 2012 14:52:06 +0800
Message-ID: <CABymN7bseS2jNxxb1ZiaO9Yu3qaPmY_HrR6O8sLuRMb5qnd74Q@mail.gmail.com>
Subject: wby mapping beyond end by "MAPPING_BEYOND_END" ?
From: Wang Baisheng <baisheng.wang.cn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

For x86, in arch/x86/kernel/head_32.S, for Initializing page tables,
why mapping beyond end by "MAPPING_BEYOND_END":

    /*
     * End condition: we must map up to the end + MAPPING_BEYOND_END.
     */
    movl $pa(_end) + MAPPING_BEYOND_END + PTE_IDENT_ATTR, %ebp
    cmpl %ebp,%eax
    jb 10b

According vmlinux.lds.S, the paging table is between __brk_base and
_end. So why map MAPPING_BEYOND_END after _end ?

Regards,
Jacky
