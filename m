Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966295Ab0GQKpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:45:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46586 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870Ab0GQKpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=B3qChgsUo30Q6AwVgcOEjUOU5NqNYHA5WqbIls7kSX/EXehTZyum5YshSFSM188hRS
         kg8MGFqJOYW2J8WZ1Yx4CWtk60/pF9icbQA2OeZ8ZZhsW4V1Ds6SnrWWAIf15sHIjJX5
         n+uNfxfDZgTc1ok2T45tnTBeyVCb5cJDGphe0=
MIME-Version: 1.0
Date: Sat, 17 Jul 2010 18:45:00 +0800
Message-ID: <AANLkTinW2C8RaI4dpkmGNoZKl5DM_V-m_M9w5BCZQjhN@mail.gmail.com>
Subject: could not catch the absolute path on intercept the mkdir() syscall in 
	linux
From: supercodeing35271 supercodeing35271 <supercodeing35271@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,i am now write a simple file comparison and protect program in
linux kernel module using the way of intercepting the syscall.What i
have done is that when the module insmod into kernel,i can appoint a
path that make any action which intend to mkdir in the path return a
fail,so the path can be protect against  malicious tamper.
How the module work is very simply as a way of  intercept the mkdir()
syscall,i think lots of guy know about the theory.
But,it is not perfect.Because the module can only identify the
absolute path.Then situation,when we open a shell like this:
root@myname-desktop:/home/myname/test# mkdir dirkkk
As this command running, a directory named dirkkk in the path
/home/myname/test has been created.Also use the command mkdir
/home/myname/test/dirkkk is the same.
But the module i wrote only realize the mkdir
/home/myname/test/dirkkk.This is the mkdir syscall function in 2.6.34:
asmlinkage long sys_mkdir(const char __user *pathname, int mode);
In my module,i intercept it and make a function named my_mkdir which
has the same parameters:
asmlinkage long my_mkdir(const char __user *pathname, int mode)
{
   if(strcmp(pathname,"/home/myname/test/dirkkk") == 0)
   {
       return -1;
   }
   return sys_mkdir(pathname,mode);
}
The module strcmp the pathname,if the pathname is which has been
setting as forbid,then return -1.Command mkdir
/home/myname/test/dirkkk may return a fail,but if mkdir dirkkk,it
doesn't forbid.Because the pathname is "dirkkk",not the
"/home/myname/test/dirkkk",it may return a original sys_mkdir.
So my question is that is any idea of identify the shell command like
mkdir if it is a absolute path or not,and how to change relative path
into absolute for my module can intercept the relative path
