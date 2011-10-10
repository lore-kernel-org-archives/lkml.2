Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1JJNJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:09:31 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:44684 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab1JJNJ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:09:29 -0400
X-AuditID: 12074425-b7f116d0000008fe-68-4e92ee88af46
Subject: Re: A Plumber???s Wish List for Linux
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20111010111813.GF17912@twin.jikos.cz>
Date: Mon, 10 Oct 2011 09:09:37 -0400
Cc: Theodore Tso <tytso@MIT.EDU>, Hugo Mills <hugo-lkml@carfax.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, Chris Mason <chris.mason@oracle.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4C18E3B8-FA7E-4BC1-BE5D-B517004321A2@mit.edu>
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk> <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com> <20111007113820.3b8424a8@lxorguk.ukuu.org.uk> <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com> <20111007152137.GE28351@carfax.org.uk> <20111010111813.GF17912@twin.jikos.cz>
To: dave@jikos.cz
X-Mailer: Apple Mail (2.1244.3)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0gUYRSG+2Znx3F1ZFwtvzSNBkQx1wyjBjExkBqRTOhHJWGN7ugu7q7L
	zGrqn4yyTFRUXK1FxLA0L7AihIuC1tLN2yJaUiaLZRe8o4sFadKMi5d/7znPeV/Ox3dwmfKd
	PBDXGkwcb2B1FKZAlR7xYarS5ZqU6MYBFd1hfY3SFUNzGL34bQCl66ZsMtrR9AjQv9Z65LRt
	pgmjJ7ocGP278iegx2efe9ATvQ1YghfT7OhBmMrlNxhTW9qGMktfU5mSwW45s/pjCmU+WFcA
	s9L/EWNc3SHMqjUpVZGmiFNzOm0+x5+Iv6nQdD17gRp7sYIxe4msGDyUlwFPHJKnYFvfOurW
	h+CY04qVAQWuJPsB7Psz4eEuugDcbKhG3MUwAlfMzm2LHxkFx1zDIsBxgoyBC1uI1JaREfDT
	1ty2xkgKTq8NoNKIpzjisnhJEiVDYaMlxD39D4HO6TNufRy2PFmQSZogY6HZVuYhaSXpRODk
	+2uS9id94cDyK8y981HYfM8FqoCvZW8Hy74dLPtSm4CsHQSr9UUqPavVCVymSshkDQaOV9FR
	eq0pilPndYPt/0oMtYEqO2UHJA4obyI6tiZFKWfzhUK9HRzGEeogMbIotnwyctWFGlbQ3ODz
	dJxgBxCXUf5EjlNkhJotLOL43B0UhKNUALFgS0hRktmsicvhOCPH79AjOE5BYnNJNPryXDZX
	kKXVmfYwgntK4d5i+Lo0QwhGVi9os918CBwLDCBw8cCUpAQ0eYZd7879zYMA8Sl+bru3eJ27
	7nkxGBGD62u3g03sHgosBvW+4+XykknW8uXWTNyVDK4z5nP02H1g2Ri+nnp3ZJ3g2RZ5q+vB
	OecgqzO1J452zDRZFdmt1rcbkaPlMRf/Oi44HeaarLM5PW2RyRWds8bbaYWnifSal9aopAPm
	4DDhavfqpfON1WFBoOpyjs/Tx8Pp4XVr6y3huckB5u8rdyhU0LAnI2S8wP4HW1xvhFoDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 10, 2011, at 7:18 AM, David Sterba wrote:

> "Resetting the UUID on btrfs isn't a quick-and-easy thing - you have to
> walk the entire tree and change every object. We've got a bad-hack in
> meego that uses btrfs-debug-tree and changes the UUID while it runs
> the entire tree, but it's ugly as hell."

Changing the UUID is going to be harder for ext4 as well, once we integrate metadata checksums.   So while it makes sense to have on-line ways of updating labels for mounted file systems it probably makes muchness sense to support it for UUIDs.

I suspect what it means in practice is that it will be useful for file systems to provide fs image copying tools that also generate a new UUID while you're at it, for use by IT administrators and embedded systems manufacturers.

-- Ted