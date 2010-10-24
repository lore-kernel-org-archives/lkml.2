Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0JXQX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:23:28 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:37280 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0JXQX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:23:28 -0400
Date: Sun, 24 Oct 2010 17:23:02 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: perf timechart segfault
Message-ID: <20101024162302.GA5586@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've run into a couple of issues using perf timechart:

1. (On 2.6.36) If I issue
   echo 0 > /proc/sys/kernel/perf_event_paranoid
   as root before running
   perf timechart record echo
   as a normal user the following is printed:

   Fatal: Permission error - are you root?
  	 Consider tweaking /proc/sys/kernel/perf_event_paranoid.

   Shouldn't it just say it needs root permissions for a timechart
   record?

2. (On -tip) Running
   perf timechart record echo
   outputs
   invalid or unsupported event: 'power:power_start'
   Run 'perf list' for a list of valid events

3. (On 2.6.36) I can't seem to convince timechart to ever capture more
   than 34000 samples. When trying to record using
   perf timechart record -fga sleep 10
   and then creating a graph using perf timechart, it only ever outputs
   a few seconds worth.

-- 
Sitsofe | http://sucs.org/~sits/
