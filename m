Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0HTTeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:34:24 -0400
Received: from n75.bullet.mail.sp1.yahoo.com ([98.136.44.51]:45213 "HELO
	n75.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752910Ab0HTTeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:34:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 994172.62339.bm@omp201.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=cA53Xq/q8yLU7O7oSPeJ/c1QwhAmCgH9qbxlgmWVa46TmCcvo3gzJNLROX6TXIEqTbM5Lq7xBb0Fszpt/xkt6mxMehXylqXKR+w1HTyqNF3I4CAgFEYqNiB1DsAmW1fpdBltLchLuI9/Ug6aJGBUYqvORFDH7D5H9OFnbZCjepI=;
Message-ID: <833804.70876.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: S2gqQZwVM1kt0qG9kOsOmEfPqcgioud49vOdL.YDe_XW.zp
 FpYSEERKeL7thei8zzpN4j9oP_qS8nchKJ56KS3FaZ4g0lTbcMtX8F4LSpr4
 8k8ju6g8j.nBZSZv7uIOXr_Uw3bCvVKjfutG9ODZ4LKUO9NJEjaVDnZCg1XE
 c3ACGhql.hed3FtoV0m1EMzIX0FMXzxzMuHZyBcDwUI0cx3l3zJJ0oZuT8Wb
 KPk4d8UiVmnia2YL6dLSWoMxgyalZyVhf6hcKG2XsI1xnqlySM3V3UYU2p7Q
 rVlj3Fyf3T6Dip_IDg9oNZH5rVPUq_4mbNbokViLn4jbF2SiwR0pyhagvjoO
 edyTTpuH6rdF_NE1x44BUKMM-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Fri, 20 Aug 2010 12:34:20 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] rndis: section mismatch fix
To: dbrownell@users.sourceforge.net,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: gregkh@suse.de, davem@davemloft.net, eric.dumazet@gmail.com,
        henne@nachtwindheim.de, tj@kernel.org, bniebuhr@efjohnson.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1282327070-5100-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 8/20/10, Henrik Kretzschmar <henne@nachtwindheim.de> wrote:

> This patch removes the following
> section mismatch warning,

Yeah, some folk have been aggressively adding bloat
to the gadget stack, starting by forcing init-only
code to stick in memory all the time, and this kind
of link bug is a symptom of code they've touched but
not fixed fully.

For now I don't see any option beyond accepting the
bloat.  Part of it is caused by non-USB tools which
also promote bloat, ignoring the fact that embedded
Linux tends not to have MegaBytes of RAM (or flash)
to waste, in the way that most x86 systems do.


