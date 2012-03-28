Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2C1JRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:17:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61104 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab2C1JRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:17:16 -0400
From: =?ISO-8859-1?Q?N=E9meth_Tam=E1s?= <nt1277@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Netlink and raw packet inconsistencies or obsolete man pages?
Date: Wed, 28 Mar 2012 11:17:14 +0200
Message-ID: <1605053.5clz4a2OYL@netadmin.sopron.nyme.hu>
User-Agent: KMail/4.8.0 (Linux/3.1.9-1.4-desktop; KDE/4.8.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man 7 netlink states that:

"Only processes with an effective UID of 0 or the CAP_NET_ADMIN capability may 
send or listen to a netlink multicast group."

In addition man 7 capabilities states that:

"CAP_NET_RAW
	Use RAW and PACKET sockets."

Despite these statements I was able to run the followinng code without getting 
any access denied type error messages:

################################
#include <sys/types.h>
#include <sys/socket.h>
#include <linux/netlink.h>
#include <unistd.h>

int filedes;
struct sockaddr_nl nladdr={AF_NETLINK,0,0,0};

int main(int argc, char *argv[], char *envp[])
{
        nladdr.nl_pid=getpid();
        filedes=socket(AF_NETLINK, SOCK_RAW, NETLINK_KOBJECT_UEVENT);
        bind(filedes,(struct sockaddr*)&nladdr,sizeof(nladdr));
        close(filedes);
}
################################

 Sorry for not testing if I can actually send or receive raw multicast netlink 
packages, this is because I'm not a programmer actually. The code above could 
be run without any problem on openSUSE 12.1's tandard kernel and on a vanilla 
2.6.32.49. Is it a bug or is it intentional (and then man pages are outdated)? 
In the latter case what does protect the udev subsystem. for example?

Regards,

Tamas Nemeth
IT sysadmin
University of West Hungary
