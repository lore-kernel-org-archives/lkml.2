Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0GUK6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 06:58:41 -0400
Received: from peer.zerties.org ([188.40.33.175]:56595 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0GUK6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 06:58:40 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: Missing config option for SFFSDR_FPGA
Date: Wed, 21 Jul 2010 12:58:33 +0200
Message-ID: <86tynthzja.fsf@peer.zerties.org>
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

        I've been running a check on the sound/ sourcetree for
config Items not defined in Kconfig and found such a case. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

There are two ifdef blocks, which do a check on CONFIG_SFFSDR_FPGA, but
this flag isn't defined anywhere. There is an select in
sound/soc/davinci[1], but Kconfig doesn't define the symbol, if there
isn't a config option for it. So this blocks can never be selected. I
don't think this is intended, so i didn't wrote a patch. Please just
notice it.

Regards
        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de/
[1] sound/soc/davinci/Kconfig:      select SFFSDR_FPGA                 
    sound/soc/davinci/davinci-sffsdr.c:#ifdef CONFIG_SFFSDR_FPGA
    sound/soc/davinci/davinci-sffsdr.c:#ifndef CONFIG_SFFSDR_FPGA
    sound/soc/davinci/davinci-sffsdr.c:#ifndef CONFIG_SFFSDR_FPGA
-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
