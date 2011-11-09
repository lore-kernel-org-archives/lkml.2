Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1KITI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:08:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61364 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1KITIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:08:55 -0500
Date: Wed, 9 Nov 2011 20:08:48 +0100
From: Clement LECIGNE <clemun@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG][SECURITY] Kernel stack overflow in hfs_mac2asc()
Message-ID: <20111109190802.GA4540@ounaide>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

I have found there is no len nor bound checkings in hfs_mac2asc()
function against the size of the out buffer passed as parameter.
The src size can be greater than HFS_MAX_NAMELEN on malformed file
system. HFS_MAX_NAMELEN is 31 whereas src size can be set up to
255 (unsigned char).

This can lead to a basic kernel stack overflow with user controlled
data through for example hfs_readdir() which calls hfs_mac2asc() with
out buffer "allocated" on the stack.

This overflow can be simply fixed by adding bound checks on srclen
before doing the copy.

Best regards,

-- 
Clément LECIGNE,
"In Python, how do you create a string of random characters? Read a Perl
file!"
