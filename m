Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0EIXCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:02:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:46616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0EIXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:02:09 -0400
Date: Sun, 9 May 2010 16:02:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 0/2] Some improvements to the cpuidle menu governor
Message-ID: <20100509160242.2e351e6a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

two patches to the menu governor that, together, boost the quality of
the decisions it makes significantly (results below).
The first patch is basically a bugfix, while the second patch adds some
smarts to the algorithm.

Both patches only impact the idle-duration predictor (for those
unfamiliar with the menu governor, the menu governor first tries to
predict the idle duration, and then uses a set of heuristics to pick
a suitable idle state based on this prediction. The better the
prediction the better the decision ends up being)

To show the quality of the predictor, I added some instrumentation
where I had perf report out the result of the current, after patch 1
and after patch 2 prediction value as well as the actual idle duration
as measured at the end of the idle period. The test run I give below had
69854 samples (other runs had pretty much the same result).

The quality indicator I use is the percentage of samples for which the
prediction is within a certain factor of the actual duration.

Factor         before patches       patch 1          patch 1+2
1.5x            29.1%               30.4%            34.1%
2x              33.6%               49.3%            52.9%
4x              43.6%               73.6%            75.2%
10x             56.9%               86.1%            86.5%
100x            78.4%               97.0%            97.2%



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
