Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0IDL5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 07:57:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab0IDL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 07:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=OUTX29VzqfkeKV88Ef3P5Z3SoJL2c6UAuLX3SCMUput0064WI5hFgGu5fQGvUJ41rs
         paMU/HgYdq8ipmi//Wx8qWb9B1ZpIgS5qVGtF0moEZ4ZkBrMD+810tvxrZwv0wYvzZEj
         6abkeDHo6M31nr6ZutpFdoZhruaWO38Grsc4E=
Message-ID: <4C823419.6050906@gmail.com>
Date: Sat, 04 Sep 2010 13:57:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>
CC: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>
Subject: apparmor: double lock
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found that you possibly double lock ns->lock:
aa_remove_profiles
  -> write_lock(&ns->lock)
  -> __remove_namespace(ns)
    -> destroy_namespace(ns)
      -> write_lock(&ns->lock)

Could you fix that if that may happen at all?

regards,
-- 
js
