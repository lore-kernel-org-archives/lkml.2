Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1LDV2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 16:28:03 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58070 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab1LDV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 16:28:01 -0500
X-Sasl-enc: Lh9+rU/y0riO2eU7lksokDeeRBvCH0gt5U2LHTY6b5sF 1323034080
Date: Sun, 4 Dec 2011 19:27:57 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1][V3] Handle reboot in a child pid namespace
Message-ID: <20111204212756.GB16362@khazad-dum.debian.net>
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Dec 2011, Daniel Lezcano wrote:
>  * V3
>    - removed lock and serialization of pid_ns_reboot
>  * V2
>    - added a lock for the pid namespace to prevent racy call
>      to the 'reboot' syscall
>    - Moved 'reboot' command assigned in zap_pid_ns_processes
>      instead of wait_task_zombie
>    - added tasklist lock around force_sig
>    - added do_exit in pid_ns_reboot
>    - used task_active_pid_ns instead of declaring a new variable in sys_reboot
>    - moved code up before POWER_OFF changed to HALT in sys_reboot

Daniel, can you address Miquel's concern?  Is it a valid concern, or
not?  I assume CAP_REBOOT functionality is still in place inside the
container, so it really does look like userspace would need to know
whether it should drop CAP_REBOOT or not, in order to automatically use
the new feature.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
