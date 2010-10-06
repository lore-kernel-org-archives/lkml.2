Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab0JFWJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:09:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab0JFWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:09:24 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: RFC: Implement hwpoison on free for soft offlining
Date: Thu,  7 Oct 2010 00:09:10 +0200
Message-Id: <1286402951-1881-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a somewhat experimental patch to improve soft offlining
in hwpoison, but allowing hwpoison on free for not directly
freeable page types. It should work for nearly all
left over page types that get eventually freed, so this makes
soft offlining nearly universal. The only non handleable page
types are now pages that never get freed.

Drawback: It needs an additional page flag. Cannot set hwpoison
directly because that would not be "soft" and cause errors.

Since the flags are scarce on 32bit I only enabled it on 64bit.

Comments?

-Andi

