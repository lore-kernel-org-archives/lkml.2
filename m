Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1FFVT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:19:26 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:50833 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1FFVTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:19:25 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1307395116!7545730!55
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jun 2011 16:19:15 -0500
Subject: RE: [PATCH] seq_file.h: introduce DECLARE_SEQ_FOPS_{RO,RW}
Thread-Topic: [PATCH] seq_file.h: introduce DECLARE_SEQ_FOPS_{RO,RW}
Thread-Index: Acwkjc+5U7BTET2gRjavr71c39SRrwAAUkWw
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B7C57@AUSP01VMBX24.collaborationhost.net>
References: <201106061319.45855.hartleys@visionengravers.com>
 <20110606210755.GL11521@ZenIV.linux.org.uk>
In-Reply-To: <20110606210755.GL11521@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 06, 2011 2:08 PM, Al Viro wrote:
> On Mon, Jun 06, 2011 at 01:19:45PM -0700, H Hartley Sweeten wrote:
>> Many of the procfs and debugfs attribute file_operations in the kernel are
>> missing the .owner information. Introduce some macro's to fill in the .owner
>> field as well as the common methods for virtual file file_operations.  This
>> simplifies creating the attributes and makes sure all the fields are properly
>> initialized.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Nacked-by: Al Viro <viro@zeniv.linux.org.uk>
> Nacked-because: too ugly
>
> Don't play that kind of games with preprocessor.

Just an FYI, the exact same thing is being done with DEFINE_SIMPLE_ATTRIBUTE
in fs.h:

#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
static int __fops ## _open(struct inode *inode, struct file *file)	\
{									\
	__simple_attr_check_format(__fmt, 0ull);			\
	return simple_attr_open(inode, file, __get, __set, __fmt);	\
}									\
static const struct file_operations __fops = {				\
	.owner	 = THIS_MODULE,						\
	.open	 = __fops ## _open,					\
	.release = simple_attr_release,					\
	.read	 = simple_attr_read,					\
	.write	 = simple_attr_write,					\
	.llseek	 = generic_file_llseek,					\
};

Regards,
Hartley
