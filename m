Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0EAOBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:01:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:59665 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750942Ab0EAOBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:01:41 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/NDAQ4Pk/NBArRsu8yjUjMQ7805ZVqsXkXWMJr7K
	7TcIZBDg+Vfz9M
Message-ID: <4BDC343A.5040901@gmx.de>
Date: Sat, 01 May 2010 16:01:30 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 02/30] viafb: use proper pci config API
References: <1272493051-25380-1-git-send-email-corbet@lwn.net> <1272493051-25380-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1272493051-25380-3-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> +	if (viaparinfo->memsize < 0) {
> +		rc = viaparinfo->memsize;
> +		goto out_delete_i2c;
> +	}

I fear this check is wrong as

struct viafb_par {
	...
	unsigned int memsize;
	...
}

so this check would as far as I see never return true *wonders why gcc 
doesn't complain about it*
Feel free to store the result in an integer or cast it back to signed or 
whatever solution you like.


Thanks,

Florian Tobias Schandinat
