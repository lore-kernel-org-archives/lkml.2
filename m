Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0DYTWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 15:22:55 -0400
Received: from keetweej.vanheusden.com ([83.163.219.98]:51832 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab0DYTWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 15:22:53 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Apr 2010 15:22:53 EDT
Date: Sun, 25 Apr 2010 21:16:43 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: disabling cache to be able to create a
	http://en.wikipedia.org/wiki/Peer_to_Peer_Remote_Copy solution
Message-ID: <20100425191643.GP4011@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Fri Apr 23 20:24:44 CEST 2010
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to achive the following

   storage a                   storage b
      |   |                     | |
      |   +--+                  | |
      | +----|------------------+ |    <- fibre
      | |    |                    |
      | |    +------------------+ |
      | |                       | |
    linux a                    linux b
      |                           |
      +-------------+  +----------+    <- iscsi
                    |  |
                   vmware

A trained eye will recognize this as a 'peer to peer remote
copy'-implementation.

So linux a (or b) receive storage requests from vmware and store those
mirrored on storage a and b: both have an md1 on their paths to storage
a and b.

Now let's say vmware talks active/passive to those linux boxes. At some
moment the left path is selected and vmware sends a block to linux a to
store on disk. Linux a stores this block on both storage systems and
_caches this block in memory_.
Then at some time, vmware switches to the path via system b and also
stores at the same block some data.
Then, vmware switches back to path a and reads again this block from
disk. Now here's where the problem comes up: linux a thinks it still has
this block in the memory-cache and serves it from there while in fact,
when the path went through system b, this block was already changed on
the storage!
So to be able to construct this mechanism, I somehow need to be able to
disable the read-cache of linux a and b. I found that you can clear the
cache by entering "echo 3 > /proc/sys/vm/drop_caches" but this can't be
automatically invoked by the vmware system when it switches paths.

Anyone got a suggestion?


Folkert van Heusden

-- 
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
