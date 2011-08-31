Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab1HaW3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:29:37 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:64373 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797Ab1HaW3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:29:35 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=eBnEfeSLl9YA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=-HNSdE-irzhh3n5YIIYA:9 a=wPNLvfGTeEIA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E5EB5CC.1010605@systemfabricworks.com>
Date: Wed, 31 Aug 2011 17:29:32 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fzago@systemfabricworks.com, rpearson@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
Subject: [PATCH v6 00/10] crc32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an attempt to resolve all the issues that were left in the last review.
There is one proposed change that is still causing a difference of opinion
which has to do with the form of the loops and their performance on x86 and ppc
This version has the change to the form that runs faster on x86 as an ifdef.

This patch series provides improved performance for computing the crc32
polynomial on common hardware by adding the Slicing-by-8 algorithm to the
existing algorithms already included. The new algorithm is very closely
related to the existing algorithm so the extension requires small changes
to implement.  Additionally it cleans up some warnings in the existing
code and adds a kernel mode optional self test to replace the existing
user mode self test.

A description of the existing and new algorithm is included in
Documentation/crc32.txt.

