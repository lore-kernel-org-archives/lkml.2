Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1BBIpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:45:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34620 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1BBIpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=vALcckI/JaojGkqhk13y8BoDAI5TX9UpIG64eaRDH37aoJ8ptqimMNBxPbrXXUZaYp
         tXR+VtAzurOpbgcfHeG3ozTZRuxLpVYcsZqrzv6goUxN0dU1+I6j1sBvLo0hLEvDUKnq
         /ADSvhbK4Wq0fzlIQvECWgTJ6TlHsqf3xIM/g=
From: Jordi Pujol <jordipujolp@gmail.com>
To: Paul Menage <menage@google.com>
Subject: Re: [RFC/RFT PATCH] cgroup: enable write permission for the group of users
Date: Wed, 2 Feb 2011 09:45:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-0.jpp.12-lnet-amd64; KDE/4.4.5; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <201102011002.09819.jordipujolp@gmail.com> <20110202012733.GA30557@elte.hu> <AANLkTimLo-ioh2+R0otCBQs93wx1hBDNTR5diXo93EQw@mail.gmail.com>
In-Reply-To: <AANLkTimLo-ioh2+R0otCBQs93wx1hBDNTR5diXo93EQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020945.19749.jordipujolp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

agree, thanks for your replies,

To be polite, for if any user finds this thread, here is a solution, the code 
added to the daemon script

set_writeperm_usergroups() {
	local mountpoint f st_mode
	mountpoint="$(awk '$1 == "cgroup" {print $2}' "/proc/mounts")"
	if [ ! -d "${mountpoint}" ]; then
		log_warning_msg "Can't find cgroups mountpoint"
		return
	fi
	while read f; do
		if st_mode="0x$(stat --format='%a' "${f}")" && \
		[ $((${st_mode} & 0x20)) -eq 0 ]; then
			chmod g+w "${f}"
		fi
	done << EOF
$(find "${mountpoint}" -type f -perm '-u=w')
EOF
}

Regards,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com
