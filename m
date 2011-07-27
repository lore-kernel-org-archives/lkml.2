Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1G0Mzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:55:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1G0Mzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:55:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Newton <will.newton@gmail.com>
Subject: Re: [PATCH] bitops: Use volatile in generic atomic bitops.
Date: Wed, 27 Jul 2011 14:55:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
References: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
In-Reply-To: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271455.39511.arnd@arndb.de>
X-Provags-ID: V02:K0:iEPYDMGcIPfAZV18nrXCgi8MqHOK5HNydKyBRaisnpi
 DVuzP4NInXBUZ0vZVZLMnnQmF1PSL41U6enxruFuJHe0nDoi5U
 Sv+FA9pgYXCWAYndedsObEtnVg4y0I6KimmlriVLxBV9mYYfvH
 WYocVovxk7g1V/3o55JiHFO+iK94UBIprOQUCOlAIjQPr8bLmF
 VpyZkkIMHafevxpBk8Qog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 July 2011, Will Newton wrote:
> The generic atomic bitops currently explicitly cast away the
> volatile from the pointer passed to them. This will allow the
> access to the bitfield to happen outside of the critical section
> thus making the bitops no longer interrupt-safe. Remove this cast
> and add a volatile keyword to make sure all accesses to the
> bitfield happen inside the critical section.
> 
> Signed-off-by: Will Newton <will.newton@imgtec.com>

Have you observed this behavior? The interrupt disable/enable should
always come with a barrier that should prevent the bitops from
leaking out, so I don't see how this causes problems in practice.

	Arnd
