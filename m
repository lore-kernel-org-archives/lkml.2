Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0IWDRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:17:16 -0400
Received: from mail.perches.com ([173.55.12.10]:2259 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0IWDRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:17:15 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] scripts/get_maintainer.pl: Add --interactive
Date: Wed, 22 Sep 2010 20:17:06 -0700
Message-Id: <cover.1285209493.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --interactive mode to allow some user interaction with the
script before returning a list of email addresses.

Using --interactive outputs to STDERR until the list of email
addresses is approved, then that list is emitted normally to STDOUT.

Duplicate email address matching is much improved, and the .mailmap file
is now used correctly.

For instance the previous RFC patch: http://lkml.org/lkml/2010/9/20/313
did not correctly identify drivers/net/sky2.c patches by Stephen Hemminger
as his maintainer address differs from his normally used submittal address.

After this patch series is applied it correctly shows:

$ ./scripts/get_maintainer.pl -i -f drivers/net/sky2.c

*  # email/list and role:stats                                        
*  1 Stephen Hemminger <shemminger@linux-foundation.org>              
     maintainer:SKGE, SKY2 10/100...
*  2 netdev@vger.kernel.org                                           
     open list:SKGE, SKY2 10/100...
*  3 linux-kernel@vger.kernel.org                                     
     open list

_#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): g

*  # email/list and role:stats                                        auth sign
*  1 Stephen Hemminger <shemminger@linux-foundation.org>                26   37
     maintainer:SKGE, SKY2 10/100...,commit_signer:37/67=55%
*  2 "David S. Miller" <davem@davemloft.net>                             7   56
     commit_signer:56/67=84%
*  3 Mike McCormack <mikem@ring3k.org>                                  15   15
     commit_signer:15/67=22%
*  4 netdev@vger.kernel.org                                           
     open list:SKGE, SKY2 10/100...
*  5 linux-kernel@vger.kernel.org                                     
     open list

_#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): b
git-blame can be very slow, please have patience...
*  # email/list and role:stats                                        auth sign
*  1 Stephen Hemminger <shemminger@linux-foundation.org>               248  265
     maintainer:SKGE, SKY2 10/100...,commit_signer:37/67=55%,authored lines:4534/5035=90%,commits:262/298=88%
*  2 "David S. Miller" <davem@davemloft.net>                             9  109
     commit_signer:56/67=84%,commits:99/298=33%
*  3 Mike McCormack <mikem@ring3k.org>                                  22   22
     commit_signer:15/67=22%,authored lines:343/5035=7%,commits:20/298=7%
*  4 Jeff Garzik <jgarzik@redhat.com>                                    3  168
     commits:168/298=56%
*  5 netdev@vger.kernel.org                                           
     open list:SKGE, SKY2 10/100...
*  6 linux-kernel@vger.kernel.org                                     
     open list

_#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): y
Stephen Hemminger <shemminger@linux-foundation.org>
"David S. Miller" <davem@davemloft.net>
Mike McCormack <mikem@ring3k.org>
Jeff Garzik <jgarzik@redhat.com>
netdev@vger.kernel.org
linux-kernel@vger.kernel.org

Joe Perches (6):
  scripts/get_maintainer.pl: Improve --interactive UI
  scripts/get_maintainer.pl: Update --interactive UI, improve hg runtime
  scripts/get_maintainer.pl: Use case insensitive name de-duplication
  scripts/get_maintainer.pl: Correct indentation in a few places
  scripts/get_maintainer.pl: Use mailmap in name deduplication and other updates
  scripts/get_maintainer.pl: Don't deduplicate unnamed addresses ie: mailing lists

florian@mickler.org (2):
  scripts/get_maintainer.pl: add interactive mode
  scripts/get_maintainer.pl: fix mailmap handling

 scripts/get_maintainer.pl | 1153 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 906 insertions(+), 247 deletions(-)

Please apply.

The current version is available to pull from:

   git://repo.or.cz/linux-2.6/get_maintainer.git 20100922_gm

-- 
1.7.3

