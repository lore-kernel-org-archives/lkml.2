Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab0FKCQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:16:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29400 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760036Ab0FKCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:16:50 -0400
Message-ID: <4C119C2E.2090801@oracle.com>
Date: Fri, 11 Jun 2010 10:15:10 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: fiemap is broken for sparse file in ext4?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C119C91.011E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted and other ext4 gurus,
	I found fiemap may be broken for sparse files in ext4. Here is a simple 
example.

dd if=/dev/zero of=testfile1 bs=1M count=1
using fiemap shows that it has a delalloc extent.
Logical: 0 Ext length: 1048576	Physical: 0	flags: 7

flags 7 means FIEMAP_EXTENT_LAST, FIEMAP_EXTENT_UNKNOWN and 
FIEMAP_EXTENT_DELALLOC,

while if we create a sparse file, fiemap will not show the delalloc extent.
dd if=/dev/zero of=testfile1 bs=1M count=1 seek=1
using fiemap shows that it has no extent for the file. while we should 
have some output like:
Logical: 1048576 Ext length: 1048576	Physical: 0	flags: 7

So we have different output with sparse and non-sparse file. Is it a bug 
for ext4?

Regards,
Tao
