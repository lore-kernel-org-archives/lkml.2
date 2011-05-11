Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1EKUEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:04:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56387 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1EKUEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:04:33 -0400
Date: Wed, 11 May 2011 17:05:04 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: torvalds@linux-foundation.org
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linville@tuxdriver.com
Subject: Revert "Bluetooth: fix shutdown on SCO sockets"
Message-ID: <20110511200503.GH22065@joana>
Mail-Followup-To: torvalds@linux-foundation.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Commit f21ca5fff6e548833fa5ee8867239a8378623150 can cause a NULL dereference
if we call shutdown in a bluetooth SCO socket and doesn't wait the shutdown
completion to call close(). Please revert it. I may have a fix for it soon,
but we don't have time anymore, so revert is the way to go. ;)

Regards,


commit f21ca5fff6e548833fa5ee8867239a8378623150
Author: Luiz Augusto von Dentz <luiz.dentz-von@nokia.com>
Date:   Fri Apr 8 17:10:41 2011 +0300

    Bluetooth: fix shutdown on SCO sockets
    
    shutdown should wait for SCO link to be properly disconnected before
    detroying the socket, otherwise an application using the socket may
    assume link is properly disconnected before it really happens which
    can be a problem when e.g synchronizing profile switch.
    
    Signed-off-by: Luiz Augusto von Dentz <luiz.dentz-von@nokia.com>
    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
http://profusion.mobi
