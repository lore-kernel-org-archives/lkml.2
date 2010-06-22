Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0FVLSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:18:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43570 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab0FVLSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=CkWR0BRPngUQMPYNVZSGHaCcs0kzE/tH/2uR/dizQEbG4YxRusgMkCAI80UmbGDotW
         e7g8FiNdVuoX4n33/J2IgdqaxGc6R7XEJn9DLdtk8jXiioA6P9s3tfifrluNxmv+UVnh
         +zwvtlgbVcDRAoSh3QBiVda12TXd1NxWkBGlA=
Message-ID: <4C209C15.9090604@gmail.com>
Date: Tue, 22 Jun 2010 13:18:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: borislav.petkov@amd.com
CC: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: intel_cacheinfo: potential NULL dereference?
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 9350f982 changed the code so it looks like:
static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
                                   const char *buf, size_t count,
                                   unsigned int slot)
{
        struct pci_dev *dev = this_leaf->l3->dev;   <<1>>
        int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
        unsigned long val = 0;

#define SUBCACHE_MASK   (3UL << 20)
#define SUBCACHE_INDEX  0xfff

        if (!this_leaf->l3 || !this_leaf->l3->can_disable)  <<2>>
                return -EINVAL;

Stanse found, that this_leaf->l3 is dereferenced at <<1>>, but checked
for being NULL at <<2>>. Is the check superfluous or the dev assignment
should go after the check?

thanks,
--
js
