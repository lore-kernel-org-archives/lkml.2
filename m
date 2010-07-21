Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0GUJXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 05:23:18 -0400
Received: from peer.zerties.org ([188.40.33.175]:37538 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0GUJXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 05:23:16 -0400
From: Christian Dietrich <stettberger@dokucode.de>
To: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Dead Config in mm/percpu.c
Date: Wed, 21 Jul 2010 11:22:51 +0200
Message-ID: <861vaxjij8.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the mm/ sourcetree for
config Items not defined in Kconfig and found 1 such case. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

We found, that CONFIG_NEED_PER_CPU_KM is a dead symbol, so it isn't defined
anywhere. Cause of that the percpu_km.c is never included anywhere. Is
this a intended dead symbol, for use in out of tree development, or is
this just an error?

Regards
        Christian Dietrich
-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
