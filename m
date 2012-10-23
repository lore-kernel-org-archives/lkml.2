Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab2JWGTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:19:00 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:52064 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:18:59 -0400
X-Greylist: delayed 2426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 02:18:58 EDT
Date: Tue, 23 Oct 2012 14:38:30 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: drm i915 hangs on heavy io load
Message-ID: <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please Cc)

I am running 3.7-rc2 and got recently hit a few times (under rc1, too)
by hanging drm i915 while doing large io operations.

The efect in the dmesg:
[13193.297751] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[13193.297758] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[13193.302728] [drm:init_ring_common] *ERROR* failed to set render ring head to zero ctl 00000000 head 85a05e3c tail 00000000 start 00003000
[13193.357584] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 85a05e3c tail 00000000 start 00003000
[13194.861769] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[13194.861838] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
[13194.861840] [drm:i915_reset] *ERROR* Failed to reset chip.

I captured the i915_error_state and uploaded it here:
	http://www.logic.at/people/preining/drm_i915_error_state.gz

The hangs have been normally initiated on svn up in a very big
repository, or git checkout on a very big repository or so.

Other system is Debian/unstable. The above output and error state is
from after a reboot without any suspends or other tricks inbetween,
uptime 3.5h.

Best wishes and thanks for any suggestions

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CORRIEMOILLIE (n.)
The dreadful sinking sensation in a long passageway encounter when
both protagonists immediately realise they have plumped for the
corriedoo (q.v.) much too early as they are still a good thirty yards
apart. They were embarrassed by the pretence of corriecravie (q.v.)
and decided to make use of the corriedoo because they felt silly. This
was a mistake as corrievorrie (q.v.) will make them seem far sillier.
			--- Douglas Adams, The Meaning of Liff
