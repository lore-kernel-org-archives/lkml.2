Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0EFXnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:43:13 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:38188 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0EFXnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=OAPAS9zH5UbnLRvE9/PHLLwTLVbAIU8P+BVRCL/v3v/Cs+SNrYM0aerGk1dc6jklvu
         sxaTEzyJJK6rE6Us4ROLDSa2w3FK2jgaa80tWh3ytSaqU9CyqYXI2BojOn9qbP3vSZF0
         BczKUx+rzjymn2xLMPXa2CNe6OlBVhygBzRGU=
MIME-Version: 1.0
Date: Thu, 6 May 2010 18:43:10 -0500
Message-ID: <l2v524f69651005061643vcdc9f7c1h780344e30c123646@mail.gmail.com>
Subject: Sparse warning: "initializer entry defined twice"
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse, but not gcc, throws a warning ("make modules C=1") as follows
on the first two lines of the following array of booleans

  CHECK   fs/smb2/misc.c
fs/smb2/misc.c:456:23: warning: Initializer entry defined twice
fs/smb2/misc.c:457:27:   also defined here


static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
    /* SMB2_NEGOTIATE */ true,
    /* SMB2_SESSION_SETUP */ true,
    /* SMB2_LOGOFF */ false,
    /* SMB2_TREE_CONNECT */    false,
    /* SMB2_TREE_DISCONNECT */ false,
    /* SMB2_CREATE */ true,
    /* SMB2_CLOSE */ false,
    /* SMB2_FLUSH */ false,
    /* SMB2_READ */    true,
    /* SMB2_WRITE */ false,
    /* SMB2_LOCK */    false,
    /* SMB2_IOCTL */ true,
    /* SMB2_CANCEL */ false, /* BB CHECK this not listed in documentation */
    /* SMB2_ECHO */ false,
    /* SMB2_QUERY_DIRECTORY */ true,
    /* SMB2_CHANGE_NOTIFY */ true,
    /* SMB2_QUERY_INFO */ true,
    /* SMB2_SET_INFO */ false,
    /* SMB2_OPLOCK_BREAK */ false
};


Any idea why sparse is complaining about the first two lines of the
arry of booleans? Is this just a sparse bug?

--
Thanks,

Steve
