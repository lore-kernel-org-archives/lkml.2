Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2GaUjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:39:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56924 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2GaUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:39:09 -0400
Message-ID: <50184289.7080108@gmail.com>
Date: Tue, 31 Jul 2012 22:39:37 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: Removing 'pos' from hlist iterators
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was working on code that uses hlists, and noticed something odd.

While list_for_each_entry needs 3 parameters (type*, head, member), hlist_for_each_entry needs 4 (everything like hlist_for_each + 'pos').

pos and tpos both serve as iterators in this case, and I think that there's no real need for this redundancy.

Would it make sense removing 'pos' out of the hlist iterators to make it more list the list iterators? The downside I see here is that it'll cause a lot of one-line changes all across the code since there are quite a few call sites.


Thanks,
Sasha
