Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab1JFOhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:37:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45361 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935622Ab1JFOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:37:08 -0400
Message-ID: <4E8DBD06.2010808@redhat.com>
Date: Thu, 06 Oct 2011 16:36:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: ecryptfs-devel@lists.launchpad.net
CC: Tyler Hicks <tyhicks@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] eCryptfs fixes for 2.6.39-rc5
References: <20110426005314.GA27036@boyd.l.tihix.com>
In-Reply-To: <20110426005314.GA27036@boyd.l.tihix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 02:53 AM, Tyler Hicks wrote:
> Hi Linus,
> 
> The first 3 patches below fix bugs when eCryptfs is mounted on top of
> NFSv3 client mount points. The 4th patch fixes a bug that occurs when
> the eCryptfs file metadata can't be read during lookup.

Hi,

I still see occasional errors:

[33945.269075] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[33945.269084] ecryptfs_readpage: Error decrypting page; rc = [-4]

that are reported as "short read: Success" when doing a "git grep" on an
encrypted repository. Redoing the grep fixes the problems for those files
and may transfer it to others, until all of them are in the cache and the
grep succeeds.

Reproduced with 3.0.3 and 3.1-rc8.

Paolo
