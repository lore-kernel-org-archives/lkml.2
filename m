Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2AZMpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 07:45:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41007 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2AZMpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 07:45:50 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: john.johansen@canonical.com
Subject: security_path hooks for xattr
CC: apparmor@lists.ubuntu.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, draht@suse.com
Date: Thu, 26 Jan 2012 13:45:27 +0100
Message-ID: <87fwf2y6mw.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding from an internal bug report:

   "AppArmor does not mediate the xattr system calls for confined processes.

   As a consequence, a confined process can cross the confinement privilege
   boundary by reading or writing to extended attributes that the confined
   task should not have access to. The restrictions for security and user
   attributes read and write still apply according to DAC; however, this
   does not comply with the claim of AppArmor to mediate fipe
   operations. The use of extended attributes is very flexible, so that the
   effect of a missing mediation can lead to false assumptions in
   subsequent policy decisions (eCryptfs)."

AFAIU this boils down to missing security hooks in *xattr().

Would it be possible to add these hooks?

Thanks,
Miklos
