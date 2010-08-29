Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0H2Tel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 15:34:41 -0400
Received: from mail.virtall.com ([178.63.195.102]:47898 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab0H2Tek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 15:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=wpkg.org; h=message-id:date
	:from:mime-version:to:cc:subject:content-type
	:content-transfer-encoding; q=dns; s=default; b=ZNQEX1hoJBkzWR6i
	QWs21PQazI5szKg4g+zmqk+vJ0DR2asmMAdWdH5kmC6bBGkuJIiAco7fV9E4Bj81
	ylyOGVHnDmK0LLzlfxFDLuKkWOc+bDdodw88JCtMmuVoLCIvjbQ/rQObJZWiyy62
	QZSAdnlGEGafS0aQX2c5/tOlenI=
Message-ID: <4C7AB645.5090804@wpkg.org>
Date: Sun, 29 Aug 2010 21:34:29 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100809 Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
CC: hch@infradead.org, gg.mariotti@gmail.com,
        "Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
        josef@redhat.com, tytso@mit.edu
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:

> There are a lot of variables when using qemu.
>
> The most important one are:
>
>  - the cache mode on the device.  The default is cache=writethrough,
>    which is not quite optimal.  You generally do want to use cache=none
>    which uses O_DIRECT in qemu.
>  - if the backing image is sparse or not.
>  - if you use barrier - both in the host and the guest.

I noticed that when btrfs is mounted with default options, when writing 
i.e. 10 GB on the KVM guest using qcow2 image, 20 GB are written on the 
host (as measured with "iostat -m -p").


With ext4 (or btrfs mounted with nodatacow), 10 GB write on a guest 
produces 10 GB write on the host.


-- 
Tomasz Chmielewski
http://wpkg.org

