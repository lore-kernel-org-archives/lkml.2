Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1JMHFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:05:22 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:36329 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751102Ab1JMHFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:05:21 -0400
From: Witold Krecicki <wpk@culm.net>
To: Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [PATCH 0/6] cgroup: add isolation_root flag, poor man's namespaces for cgroups
Date: Thu, 13 Oct 2011 09:05:01 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.6.2; x86_64; ; )
Cc: Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serue@us.ibm.com>
References: <1317382585-12172-1-git-send-email-wpk@culm.net> <CA+RrjuVOhmkMLinMkiN3pr5Yea6pBA+XNQVQ=h2bMo66VpCixg@mail.gmail.com>
In-Reply-To: <CA+RrjuVOhmkMLinMkiN3pr5Yea6pBA+XNQVQ=h2bMo66VpCixg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110130905.01960.wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia czwartek, 13 października 2011 o 07:30:27 Matthew Helsley napisał(a):
> Unless I'm misunderstanding the problem this idea does not look great. It
> looks vaguely like mount namespaces, subtree mounts, and chroot all sort of
> rolled into one and presented in a very strange interface specific to
> cgroups.
>
> We already have the ability to mount a subtree of the filesystem as if it
> were the root of that filesystem. This seems somewhat similar except we
> lack the permission to mount or see anything above that particular subtree
> (kind of like chroot).
>
> I think it would be better to make a generic way to do this with user
> namespaces and mount namespaces and without this odd flag file. It may be
> useful for other filesystems within containers.
> (...)
'Mount namespace' is just a part of this patchset, the fact that cgroups are 
exported as a filesystems is 'on top', but we need to control everything 'from 
the bottom'.
For this to really work we have to guarantee that:
1. A task inside a container will never see that it's root cgroup is an 
'isolation root' either:
 a) via cgroupfs interface
 b) via /proc/[pid]/cgroup
2. A task inside an isolation root will not be able to leave the isolation 
root it's in
3. We have full control from the outside on the isolation root

The 'mount namespaces'/mounting 'with path' is a solution only to 1b, and even 
if it'd be implemented the fact is that I can't imagine any other situation 
where this would be useful .

-- 
WK
