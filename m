Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab1JGLSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:18:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36522 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab1JGLSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:18:49 -0400
Date: Fri, 7 Oct 2011 22:18:33 +1100
From: myname <33user@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: x86: gdt_page and debugging from gdb against /proc
Message-ID: <20111007111831.GA5472@nameofcomputer>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in kernel/cpu/kernel/common.c, the initialization for the gdt_table symbol is like the following:

	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xc09a, 0, 0xfffff),
	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xc0fa, 0, 0xfffff),
	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f2, 0, 0xfffff),

	so, that the gtd_page[12] should have base = 0, and limit = 0xffffff, and so on for the next 3 slots in the array.

now if i do: `sudo gdb -q ~/linux-3.0.3/vmlinux /proc/kcore' and in gdb ask for the command p/t gdt_table, i get, which obviously if you check for base and limit in member 12, 13 and so on, doesn't fit the above description. why?

here is the output from gdb:
{{{{a = 110100000000000000000000000, b = 110100000000000000000010000}, {limit0 = 0, base0 = 11010000000, base1 = 10000, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000000000100000, b = 101110101000111}, {limit0 = 100000, base0 = 11010000000, base1 = 1000111, type = 1101, s = 1, dpl = 10, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 1000000001000100010, b = 0}, {limit0 = 1000100010, base0 = 100, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 110000000111100000000000000000}, {limit0 = 0, base0 = 0, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 1110, avl = 1, l = 0, d = 0, g = 0, base2 = 110000}}}, 
{{{a = 110100000000000000000000001, b = 110100000000000000000010001}, {limit0 = 1, base0 = 11010000000, base1 = 10001, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000001000100000, b = 11001010000110001110000010110}, {limit0 = 1000100000, base0 = 11010000000, base1 = 10110, type = 1100, s = 1, dpl = 0, p = 0, limit = 11, avl = 0, l = 0, d = 1, g = 0, base2 = 11001}}}, 
{{{a = 1000000000000110101, b = 0}, {limit0 = 110101, base0 = 100, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 111001110010010001011000110001}, {limit0 = 0, base0 = 0, base1 = 110001, type = 110, s = 1, dpl = 0, p = 0, limit = 1001, avl = 0, l = 0, d = 1, g = 1, base2 = 111001}}}, 
{{{a = 110100000000000000000000010, b = 110100000000000000000010010}, {limit0 = 10, base0 = 11010000000, base1 = 10010, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000010000100000, b = 100000000000000010001001010001}, {limit0 = 10000100000, base0 = 11010000000, base1 = 1010001, type = 10, s = 0, dpl = 1, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 100000}}}, 
{{{a = 1010000000000000000, b = 0}, {limit0 = 0, base0 = 101, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 110110101001100010000000000000}, {limit0 = 0, base0 = 0, base1 = 0, type = 0, s = 0, dpl = 1, p = 0, limit = 110, avl = 0, l = 1, d = 0, g = 1, base2 = 110110}}}, 
{{{a = 110100000000000000000000011, b = 110100000000000000000010011}, {limit0 = 11, base0 = 11010000000, base1 = 10011, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000011000100000, b = 100000000000000000000101000111}, {limit0 = 11000100000, base0 = 11010000000, base1 = 1000111, type = 1, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 100000}}}, 
{{{a = 1010000000000000000, b = 0}, {limit0 = 0, base0 = 101, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 11100000011100000010000000000000}, {limit0 = 0, base0 = 0, base1 = 0, type = 0, s = 0, dpl = 1, p = 0, limit = 0, avl = 1, l = 1, d = 1, g = 0, base2 = 11100000}}}, 
{{{a = 110100000000000000000000100, b = 110100000000000000000010100}, {limit0 = 100, base0 = 11010000000, base1 = 10100, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000100000100000, b = 100000000000000000010100111011}, {limit0 = 100000100000, base0 = 11010000000, base1 = 111011, type = 101, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 100000}}}, 
{{{a = 1010000000000000000, b = 0}, {limit0 = 0, base0 = 101, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 1011111011110010000000000000}, {limit0 = 0, base0 = 0, base1 = 0, type = 0, s = 0, dpl = 1, p = 0, limit = 1111, avl = 0, l = 1, d = 1, g = 1, base2 = 1011}}}, 
{{{a = 110100000000000000000000101, b = 110100000000000000000010101}, {limit0 = 101, base0 = 11010000000, base1 = 10101, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000101000100000, b = 100000000000000000010110101110}, {limit0 = 101000100000, base0 = 11010000000, base1 = 10101110, type = 101, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 100000}}}, 
{{{a = 1010000000000000000, b = 0}, {limit0 = 0, base0 = 101, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 1001011000010010010000000000000}, {limit0 = 0, base0 = 0, base1 = 0, type = 0, s = 0, dpl = 1, p = 0, limit = 1001, avl = 0, l = 0, d = 0, g = 0, base2 = 1001011}}}, 
{{{a = 110100000000000000000000110, b = 110100000000000000000010110}, {limit0 = 110, base0 = 11010000000, base1 = 10110, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000110000100000, b = 100000000000000000000100011001}, {limit0 = 110000100000, base0 = 11010000000, base1 = 11001, type = 1, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 100000}}}, 
{{{a = 1010000000000000000, b = 0}, {limit0 = 0, base0 = 101, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 10111001101100100010000000000000}, {limit0 = 0, base0 = 0, base1 = 0, type = 0, s = 0, dpl = 1, p = 0, limit = 10, avl = 1, l = 1, d = 0, g = 1, base2 = 10111001}}}, 
{{{a = 110100000000000000000000111, b = 110100000000000000000010111}, {limit0 = 111, base0 = 11010000000, base1 = 10111, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 1, base2 = 110}}}, 
{{{a = 110100000000000111000100000, b = 100000000000000000001110110110}, {limit0 = 111000100000, base0 = 11010000000, base1 = 10110110, type = 11, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 100000}}}, 
{{{a = 1010000000000000000, b = 0}, {limit0 = 0, base0 = 101, base1 = 0, type = 0, s = 0, dpl = 0, p = 0, limit = 0, avl = 0, l = 0, d = 0, g = 0, base2 = 0}}}, 
{{{a = 0, b = 1001100110110010010000000000000}, {limit0 = 0, base0 = 0, base1 = 0, type = 0, s = 0, dpl = 1, p = 0, limit = 1001, avl = 1, l = 0, d = 1, g = 1, base2 = 1001100}}}}}
