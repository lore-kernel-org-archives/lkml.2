Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0GUNBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:01:25 -0400
Received: from peer.zerties.org ([188.40.33.175]:51539 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab0GUNBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:01:24 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: CONFIG_SCSI_G_NCR5380_MEM dead?
Date: Wed, 21 Jul 2010 15:01:14 +0200
Message-ID: <86pqyhhtut.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the drivers/scsi sourcetree for
config Items not defined in Kconfig and found such a case. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

I encountered, that the CONFIG_SCSI_G_NCR5380_MEM symbol in
drivers/scsi/g_NCR5380.c isn't defined anywhere. So this codeblocks
seems to be unreachable. But there is a define in g_NCR5380_mmio.c for
SCSI_G_NCR5380_MEM with an include of g_NCR5380.c. So i think this is a
typo-bug and it should be a CONFIG_ define. The code wasn't changed since
linux is in git, so probably no one has used the mmio module, cause
there can't be a difference to the normal pio module. If you think this
ifdefs should be removed, i can send a patch.

Regards

        Christian Dietrich
-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
