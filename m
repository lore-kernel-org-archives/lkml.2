Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2GFQAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:00:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57458 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751694Ab2GFQAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:00:39 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/NbKYFiI/NzBJszCfJ9kKu+niSykTuzJMwxsEed/
	vuf7opiUeb5wQ1
From: Sven Joachim <svenjoac@gmx.de>
To: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: Suspend/resume/suspend broken in Linux 3.5-rc5
Date: Fri, 06 Jul 2012 18:00:35 +0200
Message-ID: <877gugzxp8.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry having to report that I'm only able to suspend once with Linux
3.5-rc5; any subsequent attempts fail.  This is a regression from 3.4
where suspend/resume worked flawlessly and arbitrarily often on my
machine.

Bisection show that the problem was introduced in commit c420b2dc8dc:

,----
| commit c420b2dc8dc3cdd507214f4df5c5f96f08812cbe
| Author: Ben Skeggs <bskeggs@redhat.com>
| Date:   Tue May 1 20:48:08 2012 +1000
| 
|     drm/nouveau/fifo: turn all fifo modules into engine modules
|     
|     Been tested on each major revision that's relevant here, but I'm sure there
|     are still bugs waiting to be ironed out.
|     
|     This is a *very* invasive change.
|     
|     There's a couple of pieces left that I don't like much (eg. other engines
|     using fifo_priv for the channel count), but that's an artefact of there
|     being a master channel list still.  This is changing, slowly.
|     
|     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
`----

My graphics cards is the following:

VGA compatible controller: NVIDIA Corporation G86 [GeForce 8500 GT] (rev a1)

Any advice would be appreciated.

Cheers,
       Sven
