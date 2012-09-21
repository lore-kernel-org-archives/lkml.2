Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2IUNtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:49:50 -0400
Received: from mailhost.elitecore.com ([203.88.135.194]:53657 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751176Ab2IUNts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:49:48 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 09:49:47 EDT
Message-ID: <505C700C.3010403@elitecore.com>
Date: Fri, 21 Sep 2012 19:17:56 +0530
From: Jagdish Motwani <jagdish.motwani@elitecore.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: performance degradation on kernel upgrade (due to commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f
 )
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: default
X-CTCH-Error: Unable to connect local ctasd
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: Default Rule
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently i upgraded my kernel from 2.6.29.6 to 2.6.35.14.

After upgrading i got very poor performance on my postgre database.


My test.sql contains 10000 postgre insert query


Linux  2.6.29.6

time psql -U user -d database -f test.sql  > /dev/null
real    0m 7.23s
user    0m 0.38s
sys     0m 0.12s



Linux  2.6.35.14

# time psql -U user -d database -f test.sql  > /dev/null
real    1m 4.05s
user    0m 0.44s
sys    0m 0.12

I even tried Linux 3.5.4 and got similar results.

Using git bisect, i got commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f

Is it a behavior change or am i missing something? Are there any 
workarounds for this?


Regards,
Jagdish Motwan
